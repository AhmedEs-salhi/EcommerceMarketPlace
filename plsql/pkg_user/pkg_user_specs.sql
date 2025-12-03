CREATE OR REPLACE PACKAGE pkg_user AS
    PROCEDURE register_client(
        v_cin          IN client.cin%TYPE,
        v_nom          IN client.nom%TYPE,
        v_email        IN client.email%TYPE,
        v_tel          IN client.telephone%TYPE,
        v_id_adresse   IN client.id_adresse_fk%TYPE DEFAULT NULL
    );
    PROCEDURE register_vendor(
            v_cin               IN vendeur.cin%TYPE,
            v_nom               IN vendeur.nom%TYPE,
            v_email             IN vendeur.email%TYPE,
            v_telephone         IN vendeur.telephone%TYPE
    );
    FUNCTION email_existe(v_email IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION authenticate_user( p_email IN VARCHAR2, p_password IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN;
END pkg_user;
/