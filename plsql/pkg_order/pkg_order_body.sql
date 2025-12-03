CREATE OR REPLACE PACKAGE BODY pkg_order AS
    FUNCTION create_order(
        p_user_id IN CLIENT.CIN%type,
        p_panier_id IN PANIER.ID_PANIER%type
    ) RETURN NUMBER IS
        CURSOR commande_items IS
            SELECT * FROM LIGNEPANIER
            WHERE ID_PANIER = p_panier_id;
        panier_count NUMBER;
        prix_produit PRODUIT.PRIX%type;
        prix_totale COMMANDE.TOTAL%type;
        order_id NUMBER;

    BEGIN
        SELECT COUNT(*) INTO panier_count
        FROM PANIER WHERE ID_PANIER = p_panier_id;
        SELECT COUNT(*) INTO order_id
        FROM COMMANDE;
        IF panier_count = 0 THEN
            raise_application_error(-20010, 'No Order could be created');
        end if;
        order_id := (order_id * 10) + 1;

        FOR item IN commande_items LOOP
            SELECT PRIX INTO prix_produit FROM PRODUIT
            WHERE ID_PRODUIT = item.ID_PRODUIT;
            prix_totale := prix_produit * item.QUANTITE;
            INSERT INTO LIGNECOMMANDE VALUES(
                order_id,
                item.ID_PRODUIT,
                item.QUANTITE,
                prix_produit,
                0,
                prix_totale
            );
        end loop;
        INSERT INTO COMMANDE VALUES(order_id, 'PENDING', NULL, p_panier_id, prix_totale);
        COMMIT;

        RETURN order_id;
    END create_order;

    PROCEDURE confirm_order(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE
    ) IS
        CURSOR commandes_cursor IS
            SELECT ID_PRODUIT_FK, QUANTITE
            FROM LIGNECOMMANDE
            WHERE ID_COMMANDE_FK = p_order_id;
        v_stock     NUMBER;
        v_needed    NUMBER;
    BEGIN
        FOR item IN commandes_cursor LOOP
            SELECT Quantite_Stock INTO v_stock
            FROM Produit
            WHERE Id_Produit = item.Id_Produit_FK;

            v_needed := item.Quantite;
            IF v_stock < v_needed THEN
                RAISE_APPLICATION_ERROR(-20020,
                    'Insufficient stock for product ' || item.Id_Produit_FK);
            END IF;

            UPDATE Produit
            SET Quantite_Stock = Quantite_Stock - v_needed
            WHERE Id_Produit = item.Id_Produit_FK;
        END LOOP;

        UPDATE Commande
        SET Statut = 'CONFIRMED'
        WHERE Id_Commande = p_order_id;

        COMMIT;
    END confirm_order;

    PROCEDURE update_status(
        p_order_id   IN COMMANDE.ID_COMMANDE%TYPE,
        p_new_status IN VARCHAR2
    ) IS
        v_current_status VARCHAR2(20);
    BEGIN
        SELECT Statut INTO v_current_status
        FROM Commande
        WHERE Id_Commande = p_order_id;

        IF v_current_status = 'PENDING' AND p_new_status NOT IN ('PAID','CANCELLED') THEN
            RAISE_APPLICATION_ERROR(-20031, 'Invalid transition from CONFIRMED');
        ELSIF v_current_status = 'PAID' AND p_new_status NOT IN ('SHIPPED','CANCELLED') THEN
            RAISE_APPLICATION_ERROR(-20032, 'Invalid transition from PAID');
        END IF;

        UPDATE Commande
        SET Statut = p_new_status
        WHERE Id_Commande = p_order_id;

        --INSERT INTO Audit_Log(entity, entity_id, action, action_date)
        --VALUES('COMMANDE', p_order_id, 'STATUS -> ' || p_new_status, SYSDATE);

        COMMIT;
    END update_status;

    PROCEDURE cancel_order(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE
    ) IS
        CURSOR commandes_cursor IS
            SELECT Id_Produit_FK, Quantite
            FROM LigneCommande
            WHERE Id_Commande_FK = p_order_id;
        v_current_status VARCHAR2(20);
    BEGIN
        SELECT Statut INTO v_current_status
        FROM Commande
        WHERE Id_Commande = p_order_id;

        IF v_current_status IN ('PAID') THEN
            RAISE_APPLICATION_ERROR(-20040, 'Order cannot be cancelled once shipped or completed');
        END IF;

        FOR item IN commandes_cursor LOOP
            UPDATE Produit
            SET Quantite_Stock = Quantite_Stock + item.Quantite
            WHERE Id_Produit = item.Id_Produit_FK;
        END LOOP;

-- I could delete the commande from the commandes table since it is not a commande anymore
-- because the user already cancel it
        UPDATE Commande
        SET Statut = 'CANCELLED'
        WHERE Id_Commande = p_order_id;

        --INSERT INTO Audit_Log(entity, entity_id, action, action_date)
        --VALUES('COMMANDE', p_order_id, 'STATUS -> CANCELLED', SYSDATE);

        COMMIT;
    END cancel_order;
END pkg_order;
/