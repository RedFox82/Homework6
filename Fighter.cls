public class Fighter {
    public String name;

    public Integer health {
        get {return health;}
        set {
            if (value > 0) {health = value;}
            else {return;}
        }
    }

    public Integer damagePerAttack {
        get {return damagePerAttack;}
        set {
            if (value > 0) {damagePerAttack = value;}
            else {return;}
        }
    }

//Creating an object "fighter" (null-object if health or damagePerAttack is null)
    public Fighter (String name, Integer health, Integer damagePerAttack) {
        this.health = health;
        this.damagePerAttack = damagePerAttack;
        if (this.health == null || this.damagePerAttack == null) {
            System.debug('Parameters "health" & "damagePerAttack" for ' + name + ' must be > 0!');
            return;
        } else {
            this.name = name;
        }
    }

//Fight action (params 1 - who strikes first)
    private static String Fighting(String name1, Integer f_health1,  Integer f_dam1,
                                    String name2, Integer f_health2, Integer f_dam2) {
        String retrn_name = '';
    //Fight till the loss of health of one of the fighters
        while ((f_health1 > 0) && (f_health2 > 0)) {
            if ((f_health2 = f_health2 - f_dam1) > 0) {
                if ((f_health1 = f_health1 - f_dam2) <= 0) {
                    retrn_name = name2;
                }
            } else {retrn_name = name1;}
        }
    //return winner's name
        return retrn_name;
    }

//Initialization of fighting parameters and "Fight action" call
    public static String Fight(Fighter fighter1, Fighter fighter2, Integer firstStart) {
        String message = '';

        if (fighter1.name != null && fighter2.name != null) {
            switch on firstStart {
                when 1 {
                    message = Fighting(fighter1.name, fighter1.health, fighter1.damagePerAttack,
                            fighter2.name, fighter2.health, fighter2.damagePerAttack);
                }
                when 2 {
                    message = Fighting(fighter2.name, fighter2.health, fighter2.damagePerAttack,
                            fighter1.name, fighter1.health, fighter1.damagePerAttack);
                }
                when else {message = 'Error of started number!';}
            }
        } else {message = 'Fighters do not exist!';}

        System.debug(message);
        return message;
    }
}