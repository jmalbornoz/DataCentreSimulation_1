/*
 * MATLAB Compiler: 4.4 (R2006a)
 * Date: Wed Oct 05 14:52:49 2011
 * Arguments: "-B" "macro_default" "-B" "sgl" "-m" "-W" "main" "-T" "link:exe"
 * "-W" "main" "make_plot_trig" "plot_trig_1" "trig_func_1" "get_input_scalar"
 * "assert_scalar" 
 */

#include <stdio.h>
#include "mclmcr.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_make_plot_trig_component_data;

#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


static int mclDefaultPrintHandler(const char *s)
{
    return fwrite(s, sizeof(char), strlen(s), stdout);
}

static int mclDefaultErrorHandler(const char *s)
{
    int written = 0, len = 0;
    len = strlen(s);
    written = fwrite(s, sizeof(char), len, stderr);
    if (len > 0 && s[ len-1 ] != '\n')
        written += fwrite("\n", sizeof(char), 1, stderr);
    return written;
}


/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_make_plot_trig_C_API 
#define LIB_make_plot_trig_C_API /* No special import/export declaration */
#endif

LIB_make_plot_trig_C_API 
bool MW_CALL_CONV make_plot_trigInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
    if (_mcr_inst != NULL)
        return true;
    if (!mclmcrInitialize())
        return false;
    if (!mclInitializeComponentInstance(&_mcr_inst,
                                        &__MCC_make_plot_trig_component_data,
                                        true, NoObjectType, ExeTarget,
                                        error_handler, print_handler))
        return false;
    return true;
}

LIB_make_plot_trig_C_API 
bool MW_CALL_CONV make_plot_trigInitialize(void)
{
    return make_plot_trigInitializeWithHandlers(mclDefaultErrorHandler,
                                                mclDefaultPrintHandler);
}

LIB_make_plot_trig_C_API 
void MW_CALL_CONV make_plot_trigTerminate(void)
{
    if (_mcr_inst != NULL)
        mclTerminateInstance(&_mcr_inst);
}

int run_main(int argc, const char **argv)
{
    int _retval;
    /* Generate and populate the path_to_component. */
    char path_to_component[(PATH_MAX*2)+1];
    separatePathName(argv[0], path_to_component, (PATH_MAX*2)+1);
    __MCC_make_plot_trig_component_data.path_to_component = path_to_component; 
    if (!make_plot_trigInitialize()) {
        return -1;
    }
    _retval = mclMain(_mcr_inst, argc, argv, "make_plot_trig", 1);
    if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
    make_plot_trigTerminate();
    mclTerminateApplication();
    return _retval;
}

int main(int argc, const char **argv)
{
    if (!mclInitializeApplication(
        __MCC_make_plot_trig_component_data.runtime_options,
        __MCC_make_plot_trig_component_data.runtime_option_count))
        return 0;
    
    return mclRunMain(run_main, argc, argv);
}
