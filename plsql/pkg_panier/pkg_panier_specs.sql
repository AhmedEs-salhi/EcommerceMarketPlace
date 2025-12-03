CREATE OR REPLACE PACKAGE pkg_panier AS
    PROCEDURE add_item(
        p_id_panier IN PANIER.ID_PANIER%type,
        p_id_produit IN PRODUIT.ID_PRODUIT%type,
        p_qty IN PANIER.NOMBRE_ARTICLE%type
    );
    PROCEDURE remove_item(
        p_id_panier IN PANIER.ID_PANIER%type,
        p_id_produit IN PRODUIT.ID_PRODUIT%type
    );
    PROCEDURE update_cart_count(
        p_id_panier IN PANIER.ID_PANIER%type
    );
    FUNCTION calculate_total(
        p_id_panier IN PANIER.ID_PANIER%type
    ) RETURN NUMBER;
END pkg_panier;
/