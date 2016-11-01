#include <fftw3.h>

int main(int argc, char** argv) {

    const int N = atoi(argv[1]);
    const int O = atoi(argv[2]);
    const int P = atoi(argv[3]);
    
    fftw_complex *in, *out;
    fftw_plan p;

//    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
//    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N*O*P);
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N*O*P);

//    p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_PATIENT);
    p = fftw_plan_dft_3d(N, O, P, in, out, FFTW_FORWARD, FFTW_ESTIMATE);


    fftw_export_wisdom_to_filename("wisdom.txt");
    fftw_print_plan(p);

    fftw_execute(p);

    fftw_destroy_plan(p);

    fftw_free(in); fftw_free(out);

    return 0;
}
