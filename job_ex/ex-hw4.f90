! hw4-iaizzi-main.f90
! Adam Iaizzi
! Fall 2012 -   Begun: 10 22 2012
! Compuational Physics
! Assignment 4: Geostationary Orbit using

! ...................................................
! Module containing common parameters
MODULE params
    IMPLICIT NONE
    ! given constants
    real(8) ::  r0         = 0.1d0    ! radius of hard core, fm
    real(8) ::  E0         = -2.226d0   ! real GS energy
    ! constants for wavefunction
    real(8) ::  beta       = -0.053667d0    ! constant  
    !experimental r
    real(8) ::  experimentalR = 2.d0        !fm

    ! variables
    real(8) ::  a                       !yukawa constant for potential
    real(8) ::  deltaA = 0.1d0          !step in a
    real(8) ::  amin = 0.1d0 !0.5d0            !minimum a = 0.5 fm
    real(8) ::  amax = 10.d0 !3.5d0            !minimum a = 3.5 fm
    real(8) ::  enratio                 ! ratio V0/E
    real(8) ::  deltaE                  !amount to increment enratio by

    real(8) ::  rmax = 100d0    ! maximum radius, fm
    integer ::  nboxes = 10000  ! number of integration steps
    real(8) ::  h               ! width of a step

    ! variable for psi, allocatable
    real(8), allocatable    ::  psi(:)

    ! variables for numerov method
    real(8) :: q0
    real(8) :: q1
    real(8) :: p1
    real(8) :: f1
    real(8) :: h2
    real(8) :: h12

    !initialization variables for numerov method
    real(8) ::   psiRMAX = 1
    real(8) ::  psiRMAXmH = 0

    ! energy bracket variables
    real(8) :: e1   !initially e negative
    real(8) :: e2   !initially e positive
    real(8) ::  psi1 !initially negative
    real(8) ::  psi2 !initially positive

    ! precision
    real(8) :: eps = 1d-4

    ! most recent value of sqrt<r^2>
    real(8) :: rcalc

END MODULE params
! ...................................................

! begin program
PROGRAM main


! ---------------------------------------------------
!               Variable Declarations
! ---------------------------------------------------

USE params
implicit NONE

! ...................................................
! function variables
real(8) ::  fNumerov
real(8) ::  exprms
real(8) ::  rfromi

! ...................................................
! internal variables

!variables for a and enratio that gives r closest to 2fm
real(8) ::  deltaR = 10
real(8) ::  armin
real(8) ::  enrmin


! iteration variables
integer ::  i

! ---------------------------------------------------
!                   Statements
! ---------------------------------------------------



! set parameters
eps=1d-6
nboxes = 10000
! set rmax
rmax = 100
! allocate psi
allocate(psi(0:nboxes))
! set h
h = (rmax-r0)/nboxes
!set initial a
a = amin

!open file
open(10,file="vr.dat")


!loop over different a with 0.5<a<3.5
do while (a <= amax+(deltaA))

    !find the initial brackets
    call findbrackets()

    !Inform user of progress
    !print*, "Boundary condition matched between e1=", real(e1), "and e2=", real(e2)
    !print*, "                            with psi1=", real(psi1),"and psi2=", real(psi2)
    !print*, "Now bisecting..."

    call bisection()

    ! set r
    rcalc = exprms()

    ! see if this is the closest we've come
    if ( abs(rcalc - experimentalR) < abs(deltaR) ) then
        deltaR = rcalc - experimentalR
        armin = a
        enrmin = enratio
    endif

    ! print results to screen
    print*, "a =", real(a), "sqrt(<r^2>) =", real(rcalc), "v0 =", real(enratio*E0)

    !write results to file (use single precision)
    write(10,*) real(a), real(enratio*E0), real(rcalc)

    ! update a
    a = a + deltaA

enddo

! close file
close(10)

!print results, r value that most accurately predicted
!print*, "============================================="
!print*, "Final result, r determined to be ", real(2d0+deltaR)
!print*, "using a =", real(armin),"and v0 =", real(E0*enrmin)
!print*, "============================================="
!print*, "Now calculating wavefunction for those parameters and writing to file..."


!open output file to hold wavefunction
open(15,file="psi.dat")

!reset parameters
a = 1.245949d0
enratio = -77.357872d0/E0
!integrate for wavefunction
call integrate()
call normalize()

!loop over indices and write to psi.dat, format:
! r     psi
do i=0,nboxes
    write(15,*) real(rfromi(i)), psi(i)
enddo

!close wf.dat
close(15)

! ---------------------------------------------------
!                   Internal Subroutines
! ---------------------------------------------------
STOP
CONTAINS


! ...................................................
SUBROUTINE bisection()
! this subroutine brackets the energy until psi(0) converges to the appropriate accuracy


    do while ( abs(psi(0)) > eps)
        !pick midpoint:
        enratio = (e1 + e2)/2d0
        ! integrate
        call integrate()
        ! print results
        !print*, real(enratio), real(psi(0))

        ! if psi(0) is positive, then set e2 = enratio and p2 to psi(0)
        if (psi(0) > 0) then
            e2 = enratio
            psi2 = psi(0)
        else  ! if psi(0) negative
            e1 =enratio
            psi1 = psi(0)
        endif

        if (abs(psi(0)) <= eps) then
            enratio = (e1 + e2)/2d0
            exit
        endif


    enddo



return
END SUBROUTINE bisection


! ...................................................
SUBROUTINE findbrackets()
! this subroutine finds the sign change in the inner BC 

    USE params
    IMPLICIT NONE
    ! iteration variable
    integer :: ii
    ! 

    ! delta energy
    deltaE = 0.1

    enratio = 0
    do ii=1,1000000
        ! set enratio
        enratio = dble(ii)*deltaE

        !integrate to find psi(r0)
        call integrate()


        ! read out values once we get close
        if ( (psi(0) < 0.1) .OR. (mod(ii,10) == 0 )) then
            !print*, ii, psi(0), real(enratio), real(enratio * E0)
        endif

        ! when psi changes sign
        if (psi(0) < 0) then
            ! test emin to enratio
            e1 = enratio
            psi1 = psi(0)
            !break from loop
            exit
        else !if psi(0) positive
            e2 = enratio
            psi2 = psi(0)
        endif

        if (ii == 1000000) print*, "ERROR, exceeded max number of steps"
    enddo

return
END SUBROUTINE findbrackets

! ...................................................
SUBROUTINE integrate()
! this subroutine integrates psi from the initial condition to r0 using the numerov method

    USE params
    IMPLICIT NONE
    ! integer for iteration
    integer :: jj
    ! external function rfromi
    real(8) ::  rfromi

    ! initialize everything
    call initializeNumerov

    jj = nboxes
    do while ( jj >= 0)
        ! update all variables
        call numerovStep(rfromi(jj))
        ! update appropriate bit of psi
        psi(jj) = p1
        ! increment index
        jj = jj - 1
    enddo

    call normalize()


return
END SUBROUTINE integrate


! ...................................................
SUBROUTINE numerovStep(r)
! this function increments a single step in the numerov method

    USE params
    IMPLICIT NONE
    ! variable for r and temporarily storing q2
    real(8)     :: r,q2
    ! external function fNumerov
    real(8)     ::  fNumerov

    ! calculate q2
    q2 = h2*f1*p1+2.d0*q1-q0

    ! update q1 and q0 for next step
    q0 = q1
    q1 = q2

    ! set f1 for the next step
    f1 = fNumerov(r)

    ! update p1
    p1 = q1/(1.d0-h12*f1)

return
END SUBROUTINE numerovStep

! ...................................................
SUBROUTINE initializeNumerov()
! this function initializes the variables used in the numerov method to the appropriate values

    ! use params module
    USE params
    IMPLICIT NONE
    ! variable for external function 
    real(8) ::  fNumerov

    h2 = h**2
    h12 = h2/12.d0

    ! at rmax, psi is some intial guess
    psi(nboxes) = psiRMAX
    psi(nboxes-1) = psiRMAXmH

    ! set p1
    p1 = psi(nboxes)

    ! set f1 for zeroth step
    f1 = fNumerov(rmax)

    ! set q0
    q0 = psi(nboxes)*(psi(nboxes)-h12*f1)

    ! reset f1 for first step
    f1 = fNumerov(rmax-h)

    ! reset q1 fro first step
    q1 = psi(nboxes)*(1.d0-h12*f1)

return
END SUBROUTINE initializeNumerov

! ...................................................
SUBROUTINE normalize()
! normalizes psi

    USE params
    implicit NONE
    ! variable to store normalization
    real(8) :: norm = 0
    ! iteration variable
    integer :: kk = 0

    !first calculate normalization coefficient squared
    ! account for edgest of psi
    norm = psi(0)**2 + psi(nboxes)**2
    ! loop over middle values of psi
    do kk=1,nboxes-3,2
        norm = norm + 4.d0*psi(kk)**2 + 2.d0*psi(kk+1)**2
    enddo

    ! last step of integration
    norm = norm + 4d0* psi(nboxes-1)**2

    ! last step of simpsons rule
    norm = norm * h/3d0

    ! now take the reciprocal and sq root
    norm = 1.d0/sqrt(norm)

    ! finally, loop over psi and normalize it
    do kk=0,nboxes
        psi(kk) = norm*psi(kk)
    enddo


return
END SUBROUTINE normalize




! ...................................................



! ---------------------------------------------------
!                   End hw4-iaizzi-main
! ---------------------------------------------------
END PROGRAM main



! ---------------------------------------------------
!                   External Functions
! ---------------------------------------------------

real(8) function fNumerov(xin)
! this program returns the value of a numerov function using a yukawa potential 
    ! include module params
    USE params

    IMPLICIT NONE

    ! inputvariable
    real(8) ::  xin

    if (xin == 0) then
        fNumerov = 0
    else
        fNumerov = beta * ( enratio * a * EXP(-xin/a) / xin - 1d0)
    endif

return
END function fNumerov

!....................................................

real(8) function rfromi(index)
! this function takes the index of psi and turns it into a position r with respect to the origin

    USE params
    IMPLICIT NONE
    integer :: index

    rfromi = r0 + h * dble(index)
return
END function rfromi

! ...................................................
real(8) function exprms()
! this function finds the expectation value for sqrt<r^2> from psi (already normalized)

    USE params
    IMPLICIT NONE

    ! iteration variable
    integer :: k = 0
    !external function 
    real(8) :: rfromi

    !first calculate <r^2>
    ! account for edges
    exprms = rfromi(0)**2 * psi(0)**2 + rfromi(nboxes)**2 * psi(nboxes)**2
    ! loop over middle values of psi
    do k=1,nboxes-3,2
        !exprms = exprms + 4.d0 * psi(k)**2 + 2.d0* psi(k+1)**2
        exprms = exprms + 4.d0*rfromi(k)**2 * psi(k)**2 + 2.d0*rfromi(k+1)**2 * psi(k+1)**2
    enddo

    ! last step of integration
    exprms = exprms + 4.d0*rfromi(nboxes-1)**2 * psi(nboxes-1)**2

    ! last step of simpsons method
    exprms = exprms * h /3d0

    ! now take square root of exprms to get final result
    exprms = sqrt(exprms/4d0)

return
END function exprms


! ---------------------------------------------------
!               End Program
! ---------------------------------------------------


