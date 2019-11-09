static const char norm_fg[] = "#f8ffff";
static const char norm_bg[] = "#121a21";
static const char norm_border[] = "#233341";

static const char sel_fg[] = "#f8ffff";
static const char sel_bg[] = "#5B5F65";
static const char sel_border[] = "#f8ffff";

static const char urg_fg[] = "#f8ffff";
static const char urg_bg[] = "#A36257";
static const char urg_border[] = "#A36257";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
