CREATE OR REPLACE PACKAGE pkg_order AS
    FUNCTION create_order(p_user_id IN CLIENT.CIN%type, p_panier_id IN PANIER.ID_PANIER%type) RETURN NUMBER;
    PROCEDURE confirm_order(p_order_id IN COMMANDE.ID_COMMANDE%TYPE);
    PROCEDURE update_status(p_order_id IN COMMANDE.ID_COMMANDE%TYPE, p_new_status IN VARCHAR2);
    PROCEDURE cancel_order(p_order_id IN COMMANDE.ID_COMMANDE%type);
END pkg_order;
/