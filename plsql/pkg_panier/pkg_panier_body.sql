CREATE OR REPLACE PACKAGE BODY pkg_panier AS
    PROCEDURE add_item(
        p_id_panier IN LIGNEPANIER.ID_PANIER%type,
        p_id_produit IN LIGNEPANIER.ID_PRODUIT%type,
        p_qty IN LIGNEPANIER.QUANTITE%type
    ) IS
    BEGIN
        IF p_qty <= 0 THEN
            raise_application_error(-20002, 'Quantity cannot equal or below 0');
        end if;
        INSERT INTO LIGNEPANIER VALUES (
            p_id_panier,
            p_id_produit,
            p_qty
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
    END;
    PROCEDURE remove_item(
        p_id_panier IN LIGNEPANIER.ID_PANIER%type,
        p_id_produit IN LIGNEPANIER.ID_PRODUIT%type
    ) IS
        panier_quantite LIGNEPANIER.QUANTITE%type;
    BEGIN
        SELECT QUANTITE INTO panier_quantite
        FROM LIGNEPANIER
        WHERE ID_PANIER = p_id_panier AND ID_PRODUIT = p_id_produit;

        IF panier_quantite - 1 <= 0 THEN
            DELETE FROM LIGNEPANIER
            WHERE ID_PANIER = p_id_panier AND ID_PRODUIT = p_id_produit;
        end if;

        UPDATE LIGNEPANIER
        SET QUANTITE = panier_quantite - 1
        WHERE p_id_panier = ID_PANIER AND p_id_produit = ID_PRODUIT;
    END;
    PROCEDURE update_cart_count(
        p_id_panier IN PANIER.ID_PANIER%type
    ) IS
    BEGIN

    END;
    FUNCTION calculate_total(
        p_id_panier IN LIGNEPANIER.ID_PANIER%type
    ) RETURN PAIEMENT.MONTANT%type
    IS
        CURSOR cursor_panier IS
            SELECT ID_PRODUIT, QUANTITE FROM LIGNEPANIER
            WHERE ID_PANIER = p_id_panier;
        total PAIEMENT.MONTANT%type;
        produit_prix PRODUIT.PRIX%type;
    BEGIN

        FOR curs in cursor_panier LOOP
            SELECT prix INTO produit_prix FROM PRODUIT PR
            WHERE CURS.ID_PRODUIT = PR.ID_PRODUIT;
            total := total + (curs.QUANTITE) * (produit_prix);
        end loop;
        RETURN total;
    END;
END pkg_panier;
/