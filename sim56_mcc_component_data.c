/*
 * MATLAB Compiler: 4.4 (R2006a)
 * Date: Thu Dec 15 14:10:44 2011
 * Arguments: "-B" "macro_default" "-B" "sgl" "-m" "-W" "main" "-T" "link:exe"
 * "-W" "main" "sim56.m" "walk.m" "search.m" "loss_1.m" "loss_2.m" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_sim56_session_key[] = {
        '4', '5', 'D', '4', 'B', '6', '3', '3', 'C', 'E', '3', '3', '5', '2',
        '4', '0', 'E', '7', 'C', '2', 'A', 'D', '0', '8', '4', 'A', '4', '0',
        'F', 'A', '6', '4', '0', 'E', '2', '3', 'B', '0', 'A', '4', 'B', 'D',
        '5', 'F', 'A', '1', '2', 'A', '7', '2', '4', 'F', 'D', '5', 'F', 'C',
        'A', '3', '6', '4', 'C', 'D', '3', '1', '8', '3', '2', '8', '7', '1',
        '0', '3', 'F', '4', '3', 'F', '0', '7', '0', '4', 'E', '9', '3', '5',
        '8', '3', '2', '5', '6', '2', 'D', '6', '5', '1', 'B', '4', 'F', 'A',
        'A', '3', '5', 'D', '0', '1', '7', 'B', 'A', '9', '5', 'B', '6', '8',
        '2', 'C', '8', '4', 'E', '0', '8', 'E', 'F', '0', 'D', 'E', '5', '8',
        '9', 'E', '0', 'C', 'D', 'F', '0', '8', '9', 'B', 'E', '9', '6', '8',
        '9', 'E', '9', '3', 'C', 'C', 'C', 'F', 'E', '5', 'B', 'A', 'F', 'A',
        '3', '0', 'E', '6', '1', '9', '2', '5', '2', '2', 'C', '1', '7', '5',
        'A', '6', '0', '4', '8', '3', 'D', 'B', '7', '6', 'F', '2', '9', 'D',
        '5', 'E', '0', 'D', 'A', '1', '9', 'B', '9', 'E', '9', 'B', '3', 'B',
        '7', 'B', '6', 'F', '2', 'F', '3', '0', '9', '9', '0', '4', 'E', '9',
        'B', 'D', '1', 'D', '6', 'C', '2', '5', 'A', '1', '0', 'F', 'B', 'E',
        '2', '6', 'C', '7', 'B', 'B', 'E', '6', 'C', 'C', '1', 'B', '5', '7',
        '3', 'B', 'A', '8', '4', '7', 'D', 'F', '1', '6', '3', '6', '0', '1',
        '6', '7', 'D', '0', '\0'};

const unsigned char __MCC_sim56_public_key[] = {
        '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9',
        '2', 'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1',
        '0', '1', '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B',
        '0', '0', '3', '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1',
        '0', '0', 'C', '4', '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3',
        'A', '5', '2', '0', '6', '5', '8', 'F', '6', 'F', '8', 'E', '0', '1',
        '3', '8', 'C', '4', '3', '1', '5', 'B', '4', '3', '1', '5', '2', '7',
        '7', 'E', 'D', '3', 'F', '7', 'D', 'A', 'E', '5', '3', '0', '9', '9',
        'D', 'B', '0', '8', 'E', 'E', '5', '8', '9', 'F', '8', '0', '4', 'D',
        '4', 'B', '9', '8', '1', '3', '2', '6', 'A', '5', '2', 'C', 'C', 'E',
        '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4', 'D', '0', '8', '5',
        'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2', 'E', 'D', 'E',
        '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6', '3', '7',
        '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E', '6',
        '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
        '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1',
        'B', 'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9',
        '9', '0', '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0',
        'B', '6', '1', 'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B',
        '5', '8', 'F', 'C', '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6',
        'E', 'B', '7', 'E', 'C', 'D', '3', '1', '7', '8', 'B', '5', '6', 'A',
        'B', '0', 'F', 'A', '0', '6', 'D', 'D', '6', '4', '9', '6', '7', 'C',
        'B', '1', '4', '9', 'E', '5', '0', '2', '0', '1', '1', '1', '\0'};

static const char * MCC_sim56_matlabpath_data[] = 
    { "sim56/", "toolbox/compiler/deploy/", "toolbox/xml_toolbox/",
      "$TOOLBOXMATLABDIR/general/", "$TOOLBOXMATLABDIR/ops/",
      "$TOOLBOXMATLABDIR/lang/", "$TOOLBOXMATLABDIR/elmat/",
      "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
      "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
      "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
      "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
      "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
      "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
      "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
      "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
      "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
      "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
      "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
      "$TOOLBOXMATLABDIR/winfun/", "$TOOLBOXMATLABDIR/demos/",
      "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
      "toolbox/local/", "toolbox/compiler/" };

static const char * MCC_sim56_classpath_data[] = 
    { "" };

static const char * MCC_sim56_libpath_data[] = 
    { "" };

static const char * MCC_sim56_app_opts_data[] = 
    { "" };

static const char * MCC_sim56_run_opts_data[] = 
    { "" };

static const char * MCC_sim56_warning_state_data[] = 
    { "" };


mclComponentData __MCC_sim56_component_data = { 

    /* Public key data */
    __MCC_sim56_public_key,

    /* Component name */
    "sim56",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_sim56_session_key,

    /* Component's MATLAB Path */
    MCC_sim56_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    35,

    /* Component's Java class path */
    MCC_sim56_classpath_data,
    /* Number of directories in the Java class path */
    0,

    /* Component's load library path (for extra shared libraries) */
    MCC_sim56_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_sim56_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_sim56_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "sim56_430ACB483DBD3738C288F95366C2C31E",

    /* MCR warning status data */
    MCC_sim56_warning_state_data,
    /* Number of MCR warning status modifiers */
    0,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


