/*
 * MATLAB Compiler: 4.4 (R2006a)
 * Date: Wed Dec 07 11:58:12 2011
 * Arguments: "-B" "macro_default" "-B" "sgl" "-m" "-W" "main" "-T" "link:exe"
 * "-W" "main" "sim55.m" "walk.m" "search.m" "loss_1.m" "loss_2.m" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_sim55_session_key[] = {
        '0', '0', '9', '2', 'B', '9', 'C', '3', '2', '3', '7', 'B', '0', 'D',
        '5', '8', '4', 'C', 'A', '9', 'C', '4', '7', 'B', 'D', '2', '5', '8',
        '9', 'E', '3', '1', '3', '2', '4', 'C', '4', 'D', 'E', 'C', '0', '0',
        'B', 'C', 'A', '3', '4', '9', 'C', '4', '2', 'C', '9', 'C', '2', 'F',
        'B', 'A', 'E', 'B', 'F', '5', '9', '9', '2', '6', '5', '4', 'F', 'C',
        'D', '8', 'B', '5', '7', '8', '8', '9', '8', 'A', '5', '0', 'B', '9',
        'E', '3', '0', 'D', 'E', '7', '9', '7', 'C', '0', 'C', '4', '8', '9',
        '4', '8', 'E', '4', '4', '4', '3', 'E', '5', 'E', 'F', 'C', '3', 'F',
        '7', '2', '8', '6', 'F', '9', '6', '3', 'F', '9', '7', '7', 'A', '1',
        '0', '8', '8', '5', '6', 'C', 'A', 'D', '7', 'A', 'D', '4', 'B', 'A',
        '7', '4', 'C', 'D', 'A', '6', '5', 'C', '8', 'A', '2', 'B', '8', 'E',
        'E', 'D', '0', '5', '7', 'C', '8', 'E', 'A', 'C', '1', '4', 'A', '1',
        '7', 'D', '8', '1', '2', '7', 'D', '5', '2', '0', '7', '8', '1', '5',
        '4', '4', 'D', '5', '2', '4', '9', '5', 'E', '5', '8', '6', '3', '7',
        '2', '7', '0', '9', 'D', '6', '5', 'D', '7', '4', 'C', 'B', 'E', 'D',
        'C', '0', '6', '7', '8', '6', '4', '6', '8', '6', '3', 'D', 'B', 'F',
        '9', '2', '0', '0', '6', 'C', 'C', '9', '5', '5', '8', 'D', 'C', '8',
        '9', 'A', '0', '7', 'E', '7', '8', '5', '4', 'A', '6', '2', '8', 'D',
        '0', 'E', '4', '4', '\0'};

const unsigned char __MCC_sim55_public_key[] = {
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

static const char * MCC_sim55_matlabpath_data[] = 
    { "sim55/", "toolbox/compiler/deploy/", "toolbox/xml_toolbox/",
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

static const char * MCC_sim55_classpath_data[] = 
    { "" };

static const char * MCC_sim55_libpath_data[] = 
    { "" };

static const char * MCC_sim55_app_opts_data[] = 
    { "" };

static const char * MCC_sim55_run_opts_data[] = 
    { "" };

static const char * MCC_sim55_warning_state_data[] = 
    { "" };


mclComponentData __MCC_sim55_component_data = { 

    /* Public key data */
    __MCC_sim55_public_key,

    /* Component name */
    "sim55",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_sim55_session_key,

    /* Component's MATLAB Path */
    MCC_sim55_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    35,

    /* Component's Java class path */
    MCC_sim55_classpath_data,
    /* Number of directories in the Java class path */
    0,

    /* Component's load library path (for extra shared libraries) */
    MCC_sim55_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_sim55_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_sim55_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "sim55_772B8FBC13525D24F18A44DC14D5F2AE",

    /* MCR warning status data */
    MCC_sim55_warning_state_data,
    /* Number of MCR warning status modifiers */
    0,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


