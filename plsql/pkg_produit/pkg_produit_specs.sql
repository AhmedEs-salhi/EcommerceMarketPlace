CREATE OR REPLACE PACKAGE pkg_produit AS
    PROCEDURE add_product(
        p_nom IN produit.nom%TYPE,
        p_prix IN produit.prix%TYPE,
        p_stock IN produit.quantite_stock%TYPE,
        p_id_categorie IN produit.id_categorie_FK%TYPE,
        p_id_vendeur IN produit.id_vendeur_FK%TYPE,
        p_id_remise IN produit.id_remise_FK%TYPE
    );
    PROCEDURE update_product(
        p_id_produit IN produit.ID_PRODUIT%type,
        p_nom IN produit.NOM%type,
        p_prix IN produit.PRIX%type,
        p_stock IN produit.QUANTITE_STOCK%type,
        p_id_categorie IN produit.ID_CATEGORIE_FK%type,
        p_id_remise IN produit.ID_REMISE_FK%type
    );
    PROCEDURE delete_product(
        p_id_produit IN produit.ID_PRODUIT%type
    );
    FUNCTION validate_stock(
        p_id_produit IN produit.ID_PRODUIT%type,
        p_qty IN produit.QUANTITE_STOCK%type
    ) RETURN BOOLEAN;
END pkg_produit;
/