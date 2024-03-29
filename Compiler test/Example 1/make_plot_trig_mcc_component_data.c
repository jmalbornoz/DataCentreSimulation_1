/*
 * MATLAB Compiler: 4.4 (R2006a)
 * Date: Wed Oct 05 14:52:49 2011
 * Arguments: "-B" "macro_default" "-B" "sgl" "-m" "-W" "main" "-T" "link:exe"
 * "-W" "main" "make_plot_trig" "plot_trig_1" "trig_func_1" "get_input_scalar"
 * "assert_scalar" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_make_plot_trig_session_key[] = {
        '8', 'A', 'A', 'C', '7', '8', '7', '8', 'B', '2', '2', '5', '1', 'E',
        '6', '2', '3', 'B', '1', 'A', '0', '1', 'A', '0', '6', '6', 'A', '6',
        'B', 'A', '1', 'D', '4', '8', '3', '8', '2', 'B', '2', '7', '7', '3',
        'E', 'D', '0', 'A', 'D', 'B', '2', '8', '9', '3', 'E', '0', 'D', '7',
        '4', 'B', '4', 'F', '7', '6', 'D', 'D', 'F', 'D', '8', '6', '9', '8',
        'C', '9', '6', 'B', 'B', '5', '7', 'D', 'B', '7', '6', 'A', '3', '0',
        'A', 'E', '4', 'D', 'C', 'A', '1', '8', '5', '6', '1', 'F', '2', '5',
        '9', '4', '7', '7', '8', 'B', '5', '9', '5', 'B', 'A', '3', '0', '0',
        '3', '6', '7', '3', '8', '1', '6', '3', 'F', '8', 'C', '6', '0', 'B',
        '2', 'C', 'E', '2', 'C', '8', '2', '5', 'C', 'C', '7', '4', '2', 'B',
        '4', 'E', 'B', '2', 'A', '0', 'B', 'F', '8', '2', 'E', 'A', '4', '1',
        'C', 'C', '7', 'A', '7', '1', '7', '0', 'C', 'A', '2', '9', 'A', '9',
        '1', 'A', '7', '9', '6', '2', 'A', 'D', 'A', '4', 'F', '9', 'D', '1',
        '4', '6', 'D', 'A', '4', 'F', '0', '1', '1', '1', '8', '2', 'C', 'A',
        '5', 'A', '9', '4', '8', 'D', '2', 'B', '2', 'F', '7', '3', '1', '3',
        '0', '4', '0', '3', '0', '7', 'E', '1', '6', 'C', 'E', '1', '6', '4',
        'D', '6', '8', 'E', '0', '9', 'B', '5', '3', '2', '4', 'C', '2', 'D',
        '9', '8', '3', '5', '5', 'F', 'D', '7', '5', '0', '4', '1', 'F', '4',
        '0', 'B', 'F', 'A', '\0'};

const unsigned char __MCC_make_plot_trig_public_key[] = {
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

static const char * MCC_make_plot_trig_matlabpath_data[] = 
    { "make_plot_trig/", "toolbox/compiler/deploy/",
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

static const char * MCC_make_plot_trig_classpath_data[] = 
    { "" };

static const char * MCC_make_plot_trig_libpath_data[] = 
    { "" };

static const char * MCC_make_plot_trig_app_opts_data[] = 
    { "" };

static const char * MCC_make_plot_trig_run_opts_data[] = 
    { "" };

static const char * MCC_make_plot_trig_warning_state_data[] = 
    { "" };


mclComponentData __MCC_make_plot_trig_component_data = { 

    /* Public key data */
    __MCC_make_plot_trig_public_key,

    /* Component name */
    "make_plot_trig",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_make_plot_trig_session_key,

    /* Component's MATLAB Path */
    MCC_make_plot_trig_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    34,

    /* Component's Java class path */
    MCC_make_plot_trig_classpath_data,
    /* Number of directories in the Java class path */
    0,

    /* Component's load library path (for extra shared libraries) */
    MCC_make_plot_trig_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_make_plot_trig_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_make_plot_trig_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "make_plot_trig_833599E946FAD847D6330677DBB46AF8",

    /* MCR warning status data */
    MCC_make_plot_trig_warning_state_data,
    /* Number of MCR warning status modifiers */
    0,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


