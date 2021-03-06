within Modelica_LinearSystems2.Math.Matrices.LAPACK;
function dgegv "Compute generalized eigenvalues for a (A,B) system"

  input Real A[:,size(A, 1)];
  input Real B[size(A, 1),size(A, 1)];
  output Real alphaReal[size(A, 1)]
    "Real part of alpha (eigenvalue=(alphaReal+i*alphaImag)/beta)";
  output Real alphaImag[size(A, 1)] "Imaginary part of alpha";
  output Real beta[size(A, 1)] "Denominator of eigenvalue";
  output Integer info;
protected
  Integer n=size(A, 1);
  Integer lwork=2*n + max(6*n, n*n + n);
  Real Awork[n,n]=A;
  Real Bwork[n,n]=B;
  Real work[lwork];
  Real dummy1[1,1];
  Real dummy2[1,1];

  external "Fortran 77" dgegv(
    "N",
    "N",
    n,
    Awork,
    n,
    Bwork,
    n,
    alphaReal,
    alphaImag,
    beta,
    dummy1,
    1,
    dummy2,
    1,
    work,
    size(work, 1),
    info) annotation (Library="lapack");
  annotation (Documentation(info="<html>
<pre>
Lapack documentation:

   Purpose
   =======

   This routine is deprecated and has been replaced by routine DGGEV.

   DGEGV computes for a pair of n-by-n real nonsymmetric matrices A and
   B, the generalized eigenvalues (alphar +/- alphai*i, beta), and
   optionally, the left and/or right generalized eigenvectors (VL and
   VR).

   A generalized eigenvalue for a pair of matrices (A,B) is, roughly
   speaking, a scalar w or a ratio  alpha/beta = w, such that  A - w*B
   is singular.  It is usually represented as the pair (alpha,beta),
   as there is a reasonable interpretation for beta=0, and even for
   both being zero.  A good beginning reference is the book, \"Matrix
   Computations\", by G. Golub &amp; C. van Loan (Johns Hopkins U. Press)

   A right generalized eigenvector corresponding to a generalized
   eigenvalue  w  for a pair of matrices (A,B) is a vector  r  such
   that  (A - w B) r = 0 .  A left generalized eigenvector is a vector
   l such that l**H * (A - w B) = 0, where l**H is the
   conjugate-transpose of l.

   Note: this routine performs \"full balancing\" on A and B -- see
   \"Further Details\", below.

   Arguments
   =========

   JOBVL   (input) CHARACTER*1
           = 'N':  do not compute the left generalized eigenvectors;
           = 'V':  compute the left generalized eigenvectors.

   JOBVR   (input) CHARACTER*1
           = 'N':  do not compute the right generalized eigenvectors;
           = 'V':  compute the right generalized eigenvectors.

   N       (input) INTEGER
           The order of the matrices A, B, VL, and VR.  N &gt;= 0.

   A       (input/output) DOUBLE PRECISION array, dimension (LDA, N)
           On entry, the first of the pair of matrices whose
           generalized eigenvalues and (optionally) generalized
           eigenvectors are to be computed.
           On exit, the contents will have been destroyed.  (For a
           description of the contents of A on exit, see \"Further
           Details\", below.)

   LDA     (input) INTEGER
           The leading dimension of A.  LDA &gt;= max(1,N).

   B       (input/output) DOUBLE PRECISION array, dimension (LDB, N)
           On entry, the second of the pair of matrices whose
           generalized eigenvalues and (optionally) generalized
           eigenvectors are to be computed.
           On exit, the contents will have been destroyed.  (For a
           description of the contents of B on exit, see \"Further
           Details\", below.)

   LDB     (input) INTEGER
           The leading dimension of B.  LDB &gt;= max(1,N).

   ALPHAR  (output) DOUBLE PRECISION array, dimension (N)
   ALPHAI  (output) DOUBLE PRECISION array, dimension (N)
   BETA    (output) DOUBLE PRECISION array, dimension (N)
           On exit, (ALPHAR(j) + ALPHAI(j)*i)/BETA(j), j=1,...,N, will
           be the generalized eigenvalues.  If ALPHAI(j) is zero, then
           the j-th eigenvalue is real; if positive, then the j-th and
           (j+1)-st eigenvalues are a complex conjugate pair, with
           ALPHAI(j+1) negative.

           Note: the quotients ALPHAR(j)/BETA(j) and ALPHAI(j)/BETA(j)
           may easily over- or underflow, and BETA(j) may even be zero.
           Thus, the user should avoid naively computing the ratio
           alpha/beta.  However, ALPHAR and ALPHAI will be always less
           than and usually comparable with norm(A) in magnitude, and
           BETA always less than and usually comparable with norm(B).

   VL      (output) DOUBLE PRECISION array, dimension (LDVL,N)
           If JOBVL = 'V', the left generalized eigenvectors.  (See
           \"Purpose\", above.)  Real eigenvectors take one column,
           complex take two columns, the first for the real part and
           the second for the imaginary part.  Complex eigenvectors
           correspond to an eigenvalue with positive imaginary part.
           Each eigenvector will be scaled so the largest component
           will have abs(real part) + abs(imag. part) = 1, *except*
           that for eigenvalues with alpha=beta=0, a zero vector will
           be returned as the corresponding eigenvector.
           Not referenced if JOBVL = 'N'.

   LDVL    (input) INTEGER
           The leading dimension of the matrix VL. LDVL &gt;= 1, and
           if JOBVL = 'V', LDVL &gt;= N.

   VR      (output) DOUBLE PRECISION array, dimension (LDVR,N)
           If JOBVR = 'V', the right generalized eigenvectors.  (See
           \"Purpose\", above.)  Real eigenvectors take one column,
           complex take two columns, the first for the real part and
           the second for the imaginary part.  Complex eigenvectors
           correspond to an eigenvalue with positive imaginary part.
           Each eigenvector will be scaled so the largest component
           will have abs(real part) + abs(imag. part) = 1, *except*
           that for eigenvalues with alpha=beta=0, a zero vector will
           be returned as the corresponding eigenvector.
           Not referenced if JOBVR = 'N'.

   LDVR    (input) INTEGER
           The leading dimension of the matrix VR. LDVR &gt;= 1, and
           if JOBVR = 'V', LDVR &gt;= N.

   WORK    (workspace/output) DOUBLE PRECISION array, dimension (LWORK)
           On exit, if INFO = 0, WORK(1) returns the optimal LWORK.

   LWORK   (input) INTEGER
           The dimension of the array WORK.  LWORK &gt;= max(1,8*N).
           For good performance, LWORK must generally be larger.
           To compute the optimal value of LWORK, call ILAENV to get
           blocksizes (for DGEQRF, DORMQR, and DORGQR.)  Then compute:
           NB  -- MAX of the blocksizes for DGEQRF, DORMQR, and DORGQR;
           The optimal LWORK is:
               2*N + MAX( 6*N, N*(NB+1) ).

           If LWORK = -1, then a workspace query is assumed; the routine
           only calculates the optimal size of the WORK array, returns
           this value as the first entry of the WORK array, and no error
           message related to LWORK is issued by XERBLA.

   INFO    (output) INTEGER
           = 0:  successful exit
           &lt; 0:  if INFO = -i, the i-th argument had an illegal value.
           = 1,...,N:
                 The QZ iteration failed.  No eigenvectors have been
                 calculated, but ALPHAR(j), ALPHAI(j), and BETA(j)
                 should be correct for j=INFO+1,...,N.
           &gt; N:  errors that usually indicate LAPACK problems:
                 =N+1: error return from DGGBAL
                 =N+2: error return from DGEQRF
                 =N+3: error return from DORMQR
                 =N+4: error return from DORGQR
                 =N+5: error return from DGGHRD
                 =N+6: error return from DHGEQZ (other than failed
                                                 iteration)
                 =N+7: error return from DTGEVC
                 =N+8: error return from DGGBAK (computing VL)
                 =N+9: error return from DGGBAK (computing VR)
                 =N+10: error return from DLASCL (various calls)

   Further Details
   ===============

   Balancing
   ---------

   This driver calls DGGBAL to both permute and scale rows and columns
   of A and B.  The permutations PL and PR are chosen so that PL*A*PR
   and PL*B*R will be upper triangular except for the diagonal blocks
   A(i:j,i:j) and B(i:j,i:j), with i and j as close together as
   possible.  The diagonal scaling matrices DL and DR are chosen so
   that the pair  DL*PL*A*PR*DR, DL*PL*B*PR*DR have elements close to
   one (except for the elements that start out zero.)

   After the eigenvalues and eigenvectors of the balanced matrices
   have been computed, DGGBAK transforms the eigenvectors back to what
   they would have been (in perfect arithmetic) if they had not been
   balanced.

   Contents of A and B on Exit
   -------- -- - --- - -- ----

   If any eigenvectors are computed (either JOBVL='V' or JOBVR='V' or
   both), then on exit the arrays A and B will contain the real Schur
   form[*] of the \"balanced\" versions of A and B.  If no eigenvectors
   are computed, then only the diagonal blocks will be correct.

   [*] See DHGEQZ, DGEGS, or read the book \"Matrix Computations\",
       by Golub &amp; van Loan, pub. by Johns Hopkins U. Press.

   =====================================================================
</pre>
</html>"));
end dgegv;
