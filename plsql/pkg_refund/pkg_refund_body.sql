CREATE TABLE LogAction (
    Id_Log        NUMBER PRIMARY KEY,
    Entity        VARCHAR2(50) NOT NULL,        -- e.g. 'COMMANDE', 'PAIEMENT'
    Entity_Id     NUMBER NOT NULL,              -- the ID of the entity affected
    Action        VARCHAR2(200) NOT NULL,       -- description of the action
    Action_Date   DATE DEFAULT SYSDATE NOT NULL,
    User_Id_FK    VARCHAR2(20),                 -- optional: who performed the action
    CONSTRAINT fk_log_client FOREIGN KEY (User_Id_FK)
        REFERENCES Client(CIN)
);

CREATE TABLE Refund (
    Id_Refund       NUMBER PRIMARY KEY,
    Id_Commande_FK  NUMBER NOT NULL,
    Amount          NUMBER NOT NULL,
    Reason          VARCHAR2(200),
    Date_Refund     DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_refund_commande FOREIGN KEY (Id_Commande_FK)
        REFERENCES Commande(Id_Commande)
);

CREATE OR REPLACE PACKAGE BODY pkg_refund AS

    PROCEDURE process_refund(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE,
        p_reason   IN VARCHAR2
    ) IS
        v_status VARCHAR2(20);
        v_total  NUMBER;
    BEGIN
        -- Check order status and total
        SELECT Statut, Total INTO v_status, v_total
        FROM Commande
        WHERE Id_Commande = p_order_id;

        -- Only allow refund if order was paid
        IF v_status <> 'PAID' THEN
            RAISE_APPLICATION_ERROR(-20070, 'Refund only allowed for PAID orders');
        END IF;

        -- Insert refund record
        INSERT INTO Refund(Id_Refund, Id_Commande_FK, Amount, Reason, Date_Refund)
        VALUES(seq_refund.NEXTVAL, p_order_id, v_total, p_reason, SYSDATE);

        -- Update order status
        UPDATE Commande
        SET Statut = 'REFUNDED'
        WHERE Id_Commande = p_order_id;

        -- Audit log
        INSERT INTO Audit_Log(entity, entity_id, action, action_date)
        VALUES('COMMANDE', p_order_id, 'STATUS -> REFUNDED', SYSDATE);

        COMMIT;
    END process_refund;


    FUNCTION validate_refund(
        p_order_id IN COMMANDE.ID_COMMANDE%TYPE
    ) RETURN BOOLEAN IS
        v_exists NUMBER;
    BEGIN
        -- Check if refund exists for this order
        SELECT COUNT(*) INTO v_exists
        FROM Refund
        WHERE Id_Commande_FK = p_order_id;

        RETURN (v_exists > 0);
    END validate_refund;

END pkg_refund;
/
