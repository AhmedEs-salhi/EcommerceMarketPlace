CREATE OR REPLACE PACKAGE pkg_refund AS
    PROCEDURE process_refund(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE,
        p_reason   IN VARCHAR2
    );

    FUNCTION validate_refund(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE
    ) RETURN BOOLEAN;
END pkg_refund;
/
