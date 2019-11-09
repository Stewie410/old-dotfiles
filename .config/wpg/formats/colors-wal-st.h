const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#121a21", /* black   */
  [1] = "#A36257", /* red     */
  [2] = "#5B5F65", /* green   */
  [3] = "#B79962", /* yellow  */
  [4] = "#4C689A", /* blue    */
  [5] = "#88718F", /* magenta */
  [6] = "#6CADC6", /* cyan    */
  [7] = "#cad1d5", /* white   */

  /* 8 bright colors */
  [8]  = "#233341",  /* black   */
  [9]  = "#e47360",  /* red     */
  [10] = "#69798f", /* green   */
  [11] = "#ffcc6d", /* yellow  */
  [12] = "#5382d7", /* blue    */
  [13] = "#b982ca", /* magenta */
  [14] = "#78e9ff", /* cyan    */
  [15] = "#f8ffff", /* white   */

  /* special colors */
  [256] = "#121a21", /* background */
  [257] = "#f8ffff", /* foreground */
  [258] = "#f8ffff",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
