CREATE TABLE LigneCommande (
    Id_Commande_FK   NUMBER NOT NULL,
    Id_Produit_FK    NUMBER NOT NULL,
    Quantite         NUMBER NOT NULL,
    Prix_Unitaire    NUMBER NOT NULL,
    Taux_Remise      NUMBER DEFAULT 0,
    Montant_Ligne    NUMBER NOT NULL,
    CONSTRAINT pk_lignecommande PRIMARY KEY (Id_Commande_FK, Id_Produit_FK),
    CONSTRAINT fk_lignecommande_commande FOREIGN KEY (Id_Commande_FK)
        REFERENCES Commande(Id_Commande),
    CONSTRAINT fk_lignecommande_produit FOREIGN KEY (Id_Produit_FK)
        REFERENCES Produit(Id_Produit)
);
select * from commande;
truncate table ;
ALTER TABLE COMMANDE ADD Total NUMBER DEFAULT 0;
truncate table avis;
declare
    mydate date;
begin
    mydate := SYSDATE;
    dbms_output.put_line('Current Date: ' || mydate);
end;
/


    --PROCEDURE confirm_order(p_order_id IN COMMANDE.ID_COMMANDE%type);
    --PROCEDURE update_status(p_order_id IN COMMANDE.ID_COMMANDE%type, p_status IN COMMANDE.STATUT%type);
    --PROCEDURE cancel_order(p_order_id IN COMMANDE.ID_COMMANDE%type);

            /*
    PROCEDURE confirm_order(
        p_order_id IN COMMANDE.ID_COMMANDE%type
    ) IS
    BEGIN

    END;
    PROCEDURE update_status(
        p_order_id IN COMMANDE.ID_COMMANDE%type,
        p_status IN COMMANDE.STATUT%type
    ) IS
    BEGIN

    END;
    PROCEDURE cancel_order(
        p_order_id IN COMMANDE.ID_COMMANDE%type
    ) IS
    BEGIN

    END;*/
ALTER TABLE COMMANDE DISABLE CONSTRAINT FK_ID_PANIER;
ALTER PACKAGE PKG_ORDER COMPILE BODY;
TRUNCATE TABLE COMMANDE;

DECLARE
    ID NUMBER;
BEGIN
    --DBMS_OUTPUT.PUT_LINE(ABS(TRUNC(DBMS_RANDOM.RANDOM(), 4)) MOD 10000);
    ID := UUID;
    DBMS_OUTPUT.PUT_LINE(ID);
end;