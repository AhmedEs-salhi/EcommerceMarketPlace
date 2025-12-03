CREATE OR REPLACE PACKAGE BODY pkg_produit AS
    id produit.ID_PRODUIT%type := 1;
    PROCEDURE add_product(
        p_nom IN produit.nom%TYPE,
        p_prix IN produit.prix%TYPE,
        p_stock IN produit.quantite_stock%TYPE,
        p_id_categorie IN produit.id_categorie_FK%TYPE,
        p_id_vendeur IN produit.id_vendeur_FK%TYPE,
        p_id_remise IN produit.id_remise_FK%TYPE
    ) IS
    BEGIN
        INSERT INTO produit VALUES(
           id,
           p_nom,
           p_prix,
           p_stock,
           p_id_categorie,
           p_id_vendeur,
           p_id_remise
        );
        id := id + 1;
        COMMIT;
    END;

    PROCEDURE update_product(
        p_id_produit IN produit.ID_PRODUIT%type,
        p_nom IN produit.NOM%type,
        p_prix IN produit.PRIX%type,
        p_stock IN produit.QUANTITE_STOCK%type,
        p_id_categorie IN produit.ID_CATEGORIE_FK%type,
        p_id_remise IN produit.ID_REMISE_FK%type
    ) IS
    BEGIN
        UPDATE produit
        SET produit.NOM = p_nom,
            produit.PRIX = p_prix,
            produit.QUANTITE_STOCK = p_stock,
            produit.ID_CATEGORIE_FK = p_id_categorie,
            produit.ID_REMISE_FK = p_id_remise
        WHERE produit.ID_PRODUIT = p_id_produit;
        COMMIT;
    END;

    PROCEDURE delete_product(
        p_id_produit IN produit.ID_PRODUIT%type
    ) IS
        produit_quantite produit.QUANTITE_STOCK%type;
    BEGIN
        SELECT QUANTITE_STOCK INTO produit_quantite
        FROM produit
        WHERE ID_PRODUIT = p_id_produit;

        IF produit_quantite - 1 <= 0 THEN
            DELETE FROM PRODUIT WHERE ID_PRODUIT = p_id_produit;
        end if;
        UPDATE produit
        SET QUANTITE_STOCK = produit_quantite - 1
        WHERE ID_PRODUIT = p_id_produit;

        COMMIT;
    END;

    FUNCTION validate_stock(
        p_id_produit IN produit.ID_PRODUIT%type,
        p_qty IN produit.QUANTITE_STOCK%type
    ) RETURN BOOLEAN IS
        quantite_stock produit.QUANTITE_STOCK%type;
    BEGIN
        SELECT QUANTITE_STOCK INTO quantite_stock
        FROM produit WHERE ID_PRODUIT = p_id_produit;
        IF quantite_stock = p_qty THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
END pkg_produit;
/