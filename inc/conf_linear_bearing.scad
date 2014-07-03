// conf_linear_bearing

// each config is in form[d_rod, d, h, type, name] where:
//     rod_dia  is smooth rod diameter [0]
//     out_dia is outer bushing diameter needed for tight fit or bearing diameter with loose fit [1]
//     len is barrel length [2]
//     type is 0 for linear bearings, 1 is for bushings which needs to be enclosed fully. [3]
//       is it alo assumed that type 1 has flange and type 0 has not
//     name is human readable name [4]

//                  [rod_dia,   dia, length, type,                                    "name"]
conf_lb_igus =      [      8,  10.2,     10,    1,      "igus J(V)FM 0810-10 or GFM 0810-10"];
conf_lb_lm8uu =     [      8,  15.4,     24,    0,                "lm8uu bearing (standard)"];
conf_lb_lm8luu =    [      8,  15.4,     45,    0,          "lm8luu bearing (double length)"];
conf_lb_lme8uu =    [      8,  16.4,     25,    0,                          "lme8uu bearing"];
conf_lb_bronze_8 =  [      8,    16,     11,    1,       "bronze self-aligning bushing, 8mm"];

conf_lb_igus10 =    [     10,  12.2,     10,    1,                     "igus J(V)FM 1012-10"];
conf_lb_lm10uu =    [     10,  19.4,     29,    0,        "lm10uu bearing (10mm smooth rod)"];
conf_lb_lm10luu =   [     10,  19.4,     55,    0, "lm10luu bearing (10mm smooth rod, long)"];
conf_lb_bronze_10 = [     10,    16,     11,    1,      "bronze self-aligning bushing, 10mm"];

conf_lb_lm12uu =    [     12,  21.2,     30,    0,        "lm12uu bearing (12mm smooth rod)"];
conf_lb_lm12luu =   [     12,  21.2,     57,    0,   "lm12luu bearing (12mm, double length)"];

// Accessor functions
function conf_lb_rod_dia(type) = type[0];
function conf_lb_out_dia(type) = type[1];
function conf_lb_length(type) = type[2];
function conf_lb_type(type) = type[3];
function conf_lb_name(type) = type[4];