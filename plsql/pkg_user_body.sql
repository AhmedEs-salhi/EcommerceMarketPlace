    CREATE OR REPLACE PACKAGE BODY pkg_user AS
    PROCEDURE register_client(
        v_cin          IN client.cin%TYPE,
        v_nom          IN client.nom%TYPE,
        v_email        IN client.email%TYPE,
        v_tel          IN client.telephone%TYPE,
    --    v_Date         IN client.date_inscription%TYPE DEFAULT SYSDATE,
        v_id_adresse   IN client.id_adresse_fk%TYPE DEFAULT NULL
    )AS
        v_email_count NUMBER;
    BEGIN

    SELECT COUNT(*) INTO v_email_count
    FROM client
    WHERE email = v_email;

    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Email deja utilise: ' || v_email);
    END IF;

    INSERT INTO Client( cin , nom , email, telephone, date_inscription, id_adresse_fk)
    VALUES(v_cin , v_nom , v_email, v_tel , SYSDATE , v_id_adresse);

    DBMS_OUTPUT.PUT_LINE('Clien inscrit avec succes ');
    DBMS_OUTPUT.PUT_LINE('Nom : ' || v_nom);
    DBMS_OUTPUT.PUT_LINE(' Email: '|| v_email);

    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END register_client;

    PROCEDURE register_vendor(
        v_cin               IN vendeur.cin%TYPE,
        v_nom               IN vendeur.nom%TYPE,
        v_email             IN vendeur.email%TYPE,
        v_telephone         IN vendeur.telephone%TYPE
      --  v_date_inscription  IN vendeur.date_inscription%TYPE DEFAULT SYSDATE
    ) AS
    v_email_count NUMBER;
    BEGIN

    SELECT COUNT(*) INTO v_email_count
    FROM vendeur
    WHERE email = v_email;

    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Email vendeur déjà utilisé: ' || v_email);
    END IF;

    INSERT INTO Vendeur (cin, nom, email, telephone, date_inscription)
    VALUES (v_cin, v_nom, v_email, v_telephone,SYSDATE);

    DBMS_OUTPUT.PUT_LINE(' Vendeur inscrit avec succès!');
    DBMS_OUTPUT.PUT_LINE('   Entreprise: ' || v_nom);
    DBMS_OUTPUT.PUT_LINE('   Email: ' || v_email);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
    END register_vendor;

    FUNCTION email_existe(v_email IN VARCHAR2)
    RETURN BOOLEAN AS
    v_count NUMBER;
    BEGIN
     SELECT COUNT(*) INTO v_count
     FROM Client
     WHERE email = v_email;

     IF v_count > 0 THEN
        RETURN TRUE;
     END IF;

    SELECT COUNT(*) INTO v_count
    FROM Vendeur
    WHERE email = v_email;

    IF v_count > 0 THEN
        RETURN TRUE;
    END IF;

    END email_existe;

    FUNCTION authenticate_user( p_email IN VARCHAR2, p_password IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN  AS
    BEGIN
    IF NOT email_existe(p_email) THEN
       RETURN FALSE;
    END IF;

    IF p_password IS NOT NULL THEN
       RETURN (p_password = 'Oussama123');
    END IF;

    RETURN TRUE;

    EXCEPTION
    WHEN OTHERS THEN
         RETURN FALSE;
    END authenticate_user;
END pkg_user;
/