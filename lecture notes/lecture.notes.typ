#import "@preview/cetz:0.4.2"

#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")
#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    // Override equation references.
    let num = counter(eq).at(el.location())
    let content = if it.supplement == auto {
      [Equation #numbering(el.numbering, ..num)]
    } else {
      [#it.supplement~#numbering(el.numbering, ..num)]
    }
    link(el.location(), content)
  } else {
    // Other references as usual.
    it
  }
}

#let tl(tl, content) = $attach(content, tl: tl)$
#let tln(content) = $attach(content, tl: "N")$
#let tlb(content) = $attach(content, tl: "B")$
#let tlp(content) = $attach(content, tl: "P")$
#let bn = $bold(n)$
#let bv = $bold(v)$
#let bb = $bold(b)$
#let tr = $upright(T)$

= A Brief History of Attitude
== What is Attitude?
- Relative rotation between 2 reference frames (typically SC body and some inertial frame)
- A Lie Group $"SO"(3)$

== What is a Reference Frame?
- Set of mutually orthogonal basis vectors that from a right-handed coordinate system
- For our purposes "Reference Frame" and a "Rigid Body" go together
- We will deal with 2 kinds:
  - "Inertial" / "Newtonian" $==>$ Newton's laws hold
  - "Body-fixed" frame $==>$ attached to / rotating with a rigid body

== Vectors and Reference Frames
- Physical vectors exist independent of our choice of reference frame or coordinates
  #cetz.canvas({
    import cetz.draw: *
    line((0,0), (1.5cm, 0.5cm), mark: (fill: black, end: "stealth"))
    content((1.6cm, 0.25cm), $bv$)
  })
- When we want to perform calculations, we project $bold(v)$ onto a set of basis vectors and write down its components.
  $ bold(v) &= tln(v_1) bn_1 + tln(v_2) bn_2 + tln(v_3) bn_3 = vec(bn_1, bn_2, bn_3)^tr vec(tln(v_1), tln(v_2), tln(v_3)) = bold(n)^tr tln(v) \
    &= tlb(v_1) bn_1 + tlb(v_2) bn_2 + tlb(v_3) bn_3 = underbrace(vec(bn_1, bn_2, bn_3), "vectrix")^tr underbrace(vec(tlb(v_1), tlb(v_2), tlb(v_3)), "component matrix") = bold(n)^tr tlb(v) $
- It is very important to distinguish a vector from its components!

== How do we Parameterise Attitude?
- Convention: Rotation from body "B" frame to inertial "N" frame.
- Euler Angles (roll-pitch-yaw): \
  pro: Minimal (3 numbers), intuitive \
  con: Singularities (at 90°), trigonometric functions in kinematics
- Rotation Matrix: \
  pro: Non-singular, easy to rotate vectors, linear kinematics \
  con: Redundant: Nine numbers for three degrees of freedom $==>$ six constraints
- Quaternions: \
  pro: Non-singular, easy to simulate dynamics \
  con: Redundant: Four numbers for three degrees of freedom $==>$ one constraint
- Axis-Angle Vector \
  pro: Minimal, intuitive \
  con: Singularity in Kinematics at 180°
- Gibbs / Rodrigues Vector / Parameters \
  pro: Minimal, polynomial kinematics \
  con: Singularities at 180° (MRP at 360°)

== Rotation Matrices
- Transfer from body to inertial frame
$ tln(v) = tln(Q)^upright(B) tlb(v) \
  bv = vec(bn_1, bn_2, bn_3)^tr vec(tln(v_1), tln(v_2), tln(v_3)) = vec(bb_1, bb_2, bb_3)^tr vec(tlb(v_1), tlb(v_2), tlb(v_3)) \
  tln(v) = vec(bn_1 dot bv, bn_2 dot bv, bn_3 dot bv) = bn dot bv = bn dot (bb^tr tlb(v)) = underbrace((bn dot bb^tr), tln(Q)^upright(B)) tlb(v) \
  Q = vec(bn_1, bn_2, bn_3) dot mat(bb_1, bb_2, bb_3) = mat(column-gap: #5%,
    bn_1 dot bb_1, bn_1 dot bb_2, bn_1 dot bb_3;
    bn_2 dot bb_1, bn_2 dot bb_2, bn_2 dot bb_3;
    bn_3 dot bb_1, bn_3 dot bb_2, bn_3 dot bb_3;
  ) \
  = underbrace(mat(tln(b_1), tln(b_2), tln(b_3)), "body basis vectors\nin inertial components") = underbrace(vec(tlb(n_1)^tr, tlb(n_2)^tr, tlb(n_3)^tr), "inertial basis vectors\nin body components") $
*What is the inverse of $Q$?*
$ Q^tr Q = vec(tln(b_1)^tr, tln(b_2)^tr, tln(b_3)^tr) mat(tln(b_1), tln(b_2), tln(b_3)) = mat(1, 0, 0; 0, 1, 0; 0, 0, 1) = I \
  Q^(-1) Q = I ==> underbrace(Q^tr = Q^(-1), "\"Orthogonal Matrix\"")
$
*What is the determinant of $Q$?*
- $det(Q)$ measures "stretching" of vectors
- Gives volume of parallelepiped formed by columns
  #cetz.canvas({
    import cetz.draw: *
    line((0,0), (0, 1.0cm), mark: (fill: black, end: "stealth"))
    line((0,0), (1.0cm, 0.0cm), mark: (fill: black, end: "stealth"))
    line((0,0), (0.5cm, 0.5cm), mark: (fill: black, end: "stealth"))
    content((0.2cm, 1.0cm), $bb_3$)
    content((1.2cm, 0.0cm), $bb_1$)
    content((0.7cm, 0.6cm), $bb_2$)
    content((2cm, 0.5cm), $"vol" = 1$)
  })
  $==> det(Q) = 1$
- A negative determinant $==>$ reflection

== A Little Group Theory
- A group has
  1. An identity element
  2. An inverse
  3. Closed under multiplication

- Examples
  - Positive reals
  - Discrete symmetry groups, e.g. $"D4" square$
  - $N times N$ invertible Matrices $"GL"(N)$
  - Rotation $"SO"(N)$
  - Rigid body motion $"SE"(3)$

- Continuous groups are called Lie Groups
- The group of 3D rotation is called $"SO"(3)$ \
  S = "special" $==> det(Q) = 1$ \
  O = "orthogonal" $==> Q^tr = Q^(-1)$ \
  3 = $3 times 3$ matrix

= Rotation Kinematics & Quaternions Part 1
== Rotation Kinematics
*How do we integrate a gyro?*
$ omega(t) attach(-->, b: "?") dot(Q) --> Q(t) $
*Velocity in a rotating frame*
  #cetz.canvas({
    import cetz.draw: *
    line((0,0), (0, 1.0cm), mark: (fill: black, end: "stealth"))
    line((0,0), (1.0cm, 0.0cm), mark: (fill: black, end: "stealth"))
    line((0,0), (0.5cm, 0.5cm), mark: (fill: black, end: "stealth"))
    content((0.3cm, 1.0cm), $bn_3$)
    content((1.2cm, 0.0cm), $bn_1$)
    content((0.7cm, 0.6cm), $bn_2$)
    circle((4.0cm, 0.03cm), radius: (1cm, 0.5cm))
    line((4.0cm,0), (4.0cm, 1.0cm), mark: (fill: black, end: "stealth"))
    content((4.1cm, 1.15cm), $bold(omega)$)
    line((4.0cm,0), (4.5cm, -0.41cm), mark: (fill: black, end: "stealth"))
    line((4.0cm,0), (4.8cm, 0.31cm), mark: (fill: black, end: "stealth"))
    content((4.7cm, -0.6cm), $bold(b_1)$)
    content((5cm, 0.45cm), $bold(b_2)$)
    line((4.0cm,0), (4.7cm, 0), mark: (fill: blue, stroke: blue, end: "stealth"), stroke: blue)
    content((4.8cm, 0.05cm), text(fill: blue)[$bold(x)$])
  })
- From physics
  $ tln(dot(x)) = tln(omega) times tln(x) = tln(Q)^upright(B) (tlb(omega) times tlb(x)) $
- Algebraically
  $ tln(x) = Q(t) tlb(x) ==> tln(dot(x)) = dot(Q) tlb(x) + Q underbrace(tlb(dot(x)), =0) = dot(Q) tlb(x) $
- Set these equal to each other
  $ tln(dot(x)) = dot(Q) tlb(x) = Q (tlb(omega) times tlb(x)) = Q hat(omega) tlb(x) $
- The "hat map"
  $ omega times x = mat(0, -omega_3, omega_2; omega_3, 0, -omega_1; -omega_2, omega_1, 0) vec(x_1, x_2, x_3) = hat(omega) x #h(1cm) underbrace(( = -hat(x) omega), hat(omega)^tr = - hat(omega) "\"skew symmetric\"") $
- $dot(Q) tlb(x) = Q hat(omega) tlb(x)$ must hold for any $tlb(x)$
  $ ==> #box(stroke: black, inset: 5pt, baseline: 5pt, $dot(Q) = Q hat(omega)$) $
- Linear 1st order ODE (ordinary differential equation)
  $ dot(Q) = Q hat(omega) <--> dot(x) = A x ==> x(t) = e^(A t) x_0 $
- For constant $omega$
  $ Q(t) = Q_0 underbrace(e^(hat(omega) t), "Matrix exponential") $
- $omega t$ is an axis-angle vector $phi = r theta$ where $r$ is the unit vector axis and $theta$ is the angle in radians
- The exponential function maps from axis-angle vectors rotation matrices
- Useful for e.g. sampling random rotations
- Matrix-log maps from rotation matrix to axis-angle
  $ phi = caron(log)(Q) $ with the "unhat" operator.
- For small rotations $norm(phi) << 1$ we have
  $ Q = e^hat(phi) approx I + hat(phi) ==> Q x approx x + phi times x $
#cetz.canvas({
  import cetz.draw: *
  circle((4.0cm, 0.03cm), radius: (1cm, 0.5cm))
  line((4.0cm,0), (4.0cm, 1.0cm), mark: (fill: black, end: "stealth"))
  content((4.1cm, 1.15cm), $bold(omega)$)
  line((4.0cm,0), (4.9cm, 0.2cm), mark: (fill: blue, stroke: blue, end: "stealth"), stroke: blue)
  content((5.3cm, 0.23cm), text(fill: blue)[$Q bold(x)$])
  line((4.0cm,0), (4.9cm, -0.2cm), mark: (end: "stealth", fill: black))
  content((4.3cm, -0.23cm), $bold(x)$)
  line((4.9cm,-0.2), (4.9cm, 0.2cm), mark: (fill: red, stroke: red, end: "stealth"), stroke: red)
})
- Axis-angle vectors / skew-symmetric matrices are the Lie algebra $"so"(3)$ associated with the group $"SO"(3)$
- The Lie algebra is the "linearisation of the group"
- Runge-Kutta-Code
  - Rotation matrix not the best choice for simulation
== Quaternions Part 1
- We will start with planar rotations (1-DOF)
  - $-pi < theta <= pi$ has discontinuity at $pi$
  - Planar quaternion $q(theta) = vec(cos(theta / 2), sin(theta / 2)) ==> q(theta + 2 pi) = -q(theta)$
  - $q$ and $-q$ represent the same rotation
  - We say that quaternions "double cover" the rotations
Combining Planar Rotations
$ theta_3 = theta_1 + theta_2 \
q_3 = vec(cos((theta_1 + theta_2)/ 2), sin((theta_1 + theta_2)/ 2)) = mat(cos((theta_1 + theta_2)/ 2), -sin((theta_1 + theta_2)/ 2); sin((theta_1 + theta_2)/ 2), cos((theta_1 + theta_2)/ 2)) vec(1, 0) $
- We can also recognise this as a 2D rotation matrix applied to $q(0) = vec(1, 0)$.
$ ==> q_3 = mat(cos((theta_2)/ 2), -sin((theta_2)/ 2); sin((theta_2)/ 2), cos((theta_2)/ 2)) vec(cos(theta_1 / 2), sin(theta_1 / 2)) = vec(c_2 c_1 - s_2 s_1, s_2 c_1 + c_2 s_1) $
- This is equivalent to complex multiplication
  $ c_1 + s_1 i) dot (c_2 + s_2 i) = (c_1 c_2 - s_1 s_2) + i (c_1 s_2 + c_2 s_1) $
- We will introduce the notation $L(q)$
  $ q_3 = L(q_2) q_1 $
Kinematics
- Rotations have discontinuities / singularities, but angular velocity does not \
  $=>$ USE $q n RR^2$ for attitude but $omega in RR$ for velocity
- Integrate a gyro again
  $ omega --> dot(q) --> q(t) $
  $ q = vec(cos(theta / 2), sin(theta/2)) ==> (partial q)/(partial theta) = vec(- 1/2 sin(theta / 2), 1/2 cos(theta / 2)) \
    dot(q) = (partial q)/(partial theta) dot(theta) = (partial q)/(partial theta) omega = vec(- 1/2 sin(theta / 2), 1/2 cos(theta / 2)) omega $
- Some notation
  $ dot(q) = underbrace(mat(cos(theta/2), -sin(theta/2); sin(theta/2), cos(theta/2)), L(q)) vec(0, 1/2 omega) = 1/2 L(q) H omega $
  with $H = vec(0,1)$. Here $H$ plays the same role as the hat-map (and $i$). $G(q) = L(q) H$ is called the "attitude Jacobian".
$ ==> #box(stroke: black, inset: 5pt, baseline: 5pt, $dot(q) = 1/2 G(q) omega$) $
Geometry
  #cetz.canvas({
    import cetz.draw: *
    line((-1.5cm, 0), (1.5cm, 0.0cm), mark: (fill: black, end: "stealth"))
    line((0, -1.5cm), (0, 1.5cm), mark: (fill: black, end: "stealth"))
    circle((0cm, 0cm), radius: 1cm, stroke: blue)

    line((0, 0), (0.707cm, 0.707cm), mark: (fill: green, end: "stealth"), stroke: green)
    line((0.707cm, 0.707cm), (0.207cm, 1.207cm), mark: (fill: green, end: "stealth"), stroke: green)
    line((1.0cm, 0), (1.0cm, 0.7cm), mark: (fill: red, end: "stealth"), stroke: red)

    content((0.5cm, 0.3cm), text(fill: green)[$q$])
    content((0.5cm, 1.3cm), text(fill: green)[$i$])
    content((1.2cm, 0.3cm), text(fill: red)[$omega$])
  })
  - $q$ is a unit vector $==>$ lies on circle
  - $dot(q)$ is always tangent to circle (orthogonal to q)
  - $omega$ is really a tangent vector at identity ($theta = 0$)
  - Attitude Jacobian is rotating $omega$ from the tangent plane at $theta = 0$ to the tangent plane at $q$
3D Rotations
- Set of all possible axis-angle vectors $norm(bold(phi)) <= pi$ is a ball of radius $pi$.
- Just like in the planar case there is a jump (singularity) when the angle wraps around at $plus.minus pi$.
- We will play the same trick as before by stretching the disk up into a hemisphere

= Quaternions Part 2 & Rigid Body Intro
== Quaternions Part 2
- Algebraic properties
  $ q = vec(cos (theta / 2), bold(r) sin(theta / 2)) = vec(s, bold(v)) #h(2cm) (phi = bold(r) theta) $
  where the unit-vector $bold(r)$ is the axis of rotation, $theta$ is the angle of rotation, $s$ is the scalar part, $bold(v)$ is the vector part and $phi$ is the axis-angle.
- Rotations correspond to unit quaternions
  $ q^tr q = cos^2 (theta / 2) + underbrace(r^tr r, 1) sin^2(theta/2) = 1 $
  $==>$ easy to normalise (unlike rotation matrices)
- Identity quaternion is $q_0 = vec(1, 0)$.
- Quaternion inverse
  $ q^(-1) = vec(cos(-theta / 2), bold(r) sin(-theta / 2)) = vec(s, -bold(v)) = underbrace(q^dagger, "conjugate") = underbrace(mat(1, 0; 0, -I), T) vec(s, bold(v)) = T q $
- There are two quaternions for every 3D rotation
  $ vec(cos((theta + 2pi) / 2), bold(r) sin((theta + 2pi)/2)) = vec(- cos(theta/2), - bold(r) sin(theta/2)) = -q $
- Compose rotations by multiplying quaternions
  $ q_1 * q_2 = vec(s_1, bold(v_1)) * vec(s_2, bold(v_2)) = vec(s_1 s_2 - bold(v_1)^tr bold(v_2), s_1 bold(v_2) + s_2 bold(v_1) + bold(v_1) times bold(v_2)) \
    = underbrace(mat(s_1, -bold(v_1)^tr; bold(v_1), s_1 I + hat(bold(v_1))), L(q_1)) vec(s_2, bold(v_2))
    = underbrace(mat(s_2, -bold(v_2)^tr; bold(v_2), s_2 I - hat(bold(v_2))), R(q_2)) vec(s_1, bold(v_2)) $
  Note that $L(q^dagger) = L^tr (q)$, and $R(q^dagger) = R^tr (q)$.
- Rotate a vector
  $ underbrace(vec(0, tln(x)), "pure vector quaternion") = q * vec(0, tlb(x)) * q^dagger = underbrace(H^tr L(q) R^tr (q) H, tln(Q)^B (q)) tlb(x) = H^tr R^tr (q) L(q) H tlb(x) \
    H x = vec(0, x) ==> H = vec(0, I) $
- Quaternions act just like rotation matrices!
  $ Q^tr Q = I #h(0.4cm) &<--> #h(0.4cm) q^dagger q = 1 \
    Q_3 = Q_2 Q_1 #h(0.4cm) &<--> #h(0.4cm) q_3 = q_2 * q_1 = L(q_2) q_1 = R(q_1) q_2 \
    Q_1 = Q_2^tr Q_3 #h(0.4cm) &<--> #h(0.4cm) q_1 = q_2^dagger * q_3 = L^tr (q_2) q_3 = R(q_3) T q_2 \
    tln(hat(x)) = Q tlb(hat(x)) Q^tr #h(0.4cm) &<--> #h(0.4cm) H tln(x) = q * H tlb(x) * q^dagger = L(q) R^tr (q) H tlb(x) = R^tr (q) L(q) H tlb(x) $
  Note that $"hat map" <--> "pure vector quaternions"$.
- Quaternion Kinematics \
  We are looking at the changes from a small rotation $Delta q$.
  $ q_2 = q_1 * Delta q = q_1 * vec(cos(theta/2), r sin(theta/2)) approx q_1 * vec(1, r theta / 2) approx q_1 * (q_0 + 1/2 H Delta phi) \
  approx q_1 + 1/2 L(q) H Delta phi \
  ==> q_2 - q_1 / (Delta t) = (1/2 L(q_1) H Delta phi) / (Delta t) \
  ==> #box(stroke: black, inset: 5pt, baseline: 5pt, $dot(q) = 1/2 L(q) H omega = 1/2 G(q) omega$) $
  The $4 times 3$ matrix $G(q)$ is called the "attitude Jacobian".
- Quaternion Exponential
  $ q = "expq"(phi) = vec(cos(norm(phi)), phi / norm(phi) sin(norm(phi))) = vec(cos(norm(phi)), phi sinc(norm(phi))) $
  We can also define the $phi = "logq"(q)$.

== Rigid-Body Dynamics
What does "rigid" mean?
- Distances between points in the body are constant (no deformation)
- Practical: Structural modal frequencies $>>$ rigid-body frequencies $+$ controller bandwidth
- We can get pretty far modelling spacecraft as rigid bodies

Conserved Quantities
- Angular momentum
  $ tln(h) = "const" ==> norm(tlb(h)) = "const" $
- Kinetic energy
  $ T &= sum_k 1/2 m_k tln(v_k)^tr tln(v_k) = sum_k 1/2 m_k [tln(Q)^upright(B) (tlb(omega) times tlb(r_k))]^tr [tln(Q)^upright(B) (tlb(omega) times tlb(r_k))] \
    &= sum_k 1/2 m_k (omega times r_k)^tr underbrace(Q^tr Q, I) (omega times r_k) \
    &= sum_k - 1/2 m_k omega^tr hat(r_k) hat(r_k) omega = 1/2 omega^tr underbrace([- sum_k m_k hat(r_k) hat(r_k)], tlb(J)) omega \
    &= 1/2 omega^tr J omega $
  where $J$ is the moment of inertia.
- Moment of inertia
  $ tlb(J) = -sum_k m_k hat(r_k) hat(r_k) = sum_k m_k (r_k^tr r_k I - r_k r_k^tr) $
  - symmetric: $J = J^tr$
  - Diagonal in some coordinate system (real eigenvalues)
  - Coordinates where it is diagonal called "Principle axes"
  - Positive definite (cannot have negative energy $1/2 omega^tr J omega >= 0$)
  - Triangle inequality: $J_(i i) + J_(j j) >= J_(k k)$
  - Sum $-->$ integral for continuous bodies

Composing Inertias
- Body 1 with $m_1, J_1$ and body 2 with $m_2, J_2$ get linked together and $r_i$ points from the centre of mass of body $i$ to the centre of mass of the combined body.
  $ J = J_1 + J_2 + m_1(r_1^tr r_1 I - r_1 r_1^tr) + m_2 (r_2^tr r_2 I - r_2 r_2^tr) $
  1. Find new centre of mass
  2. Add inertias
  3. Add point-mass terms about new centre of mass
  This is called the "Parallel Axis Theorem"

= Rigid Body Dynamics & Stability
== Euler's Equation
$ tln(h) = tln(J)tln(omega) = "const" $
or with torques we have
$ tln(dot(h)) = tln(tau) = tln(J) tln(dot(omega)) + underbrace(tln(dot(J)), "messy") tln(omega). $
From last time we have
$ tln(x) = Q tlb(x) ==> tln(dot(x)) = Q tlb(dot(x)) + dot(Q) tlb(x) = Q tlb(dot(x)) + Q hat(omega) tlb(x) = Q(tlb(dot(x)) + tlb(omega) times tlb(x)) $
Therefore we can write
$ ==> tln(dot(h)) = tln(tau) = Q(tlb(dot(h) + tlb(omega) times tlb(h))) \
  ==> tlb(tau) = tlb(dot(h)) + tlb(omega) times tlb(h) \
  ==> #box(stroke: black, inset: 5pt, baseline: 5pt, $J tlb(dot(omega)) + tlb(omega) times J tlb(omega) = tlb(tau)$) $
This is called Euler's Equation.
In principle axes we can write
$ tlp(J_11) tlp(dot(omega)) + (tlp(J_33) - tlp(J_22)) tlp(omega_2) tlp(omega_3) = tlp(tau_1) \
  J_22 dot(omega_2) + (J_11 - J_33) omega_1 omega_3 + tau_2
  J_33 dot(omega)_3 + (J_22 - J_11) omega_1 omega_2 = tau_3 $
Generally the axes are ordered such that $J_11 <= J_22 <= J_33$. \
== How many equlibria does a spinning body have?
We can rewrite in terms of $h$
$ J dot(omega) + omega times J omega = 0 \
==> dot(h) + (J^(-1) h) times h = 0 \
==> dot(h) = h times J^(-1) h. $
Equilibrium means that $h times J^(-1) h = 0$. \
$==> h$ is an eigenvector of $J$ \
$==> h$ is parallel to a principle axis \
$==> h$ is an eigenvector of $J$ \
$==>$ 6 equilibria $plus.minus p_1, plus.minus p_2, plus.minus p_3$ \
A spin around the intermediate axis causes a "flip".
== Which Equilibria are Stable?
First we linearise about each principle axis. Assume $J_11 < J_22 < J_33$.
$ omega_1 = omega_0 >> omega_2, omega_3 \
  dot(omega_2) = underbrace(omega_0 (J_33 - J_22)/ J_22, alpha_1) omega_3, #h(1cm) dot(omega_3) = underbrace(omega_0 (J_11 - J_22) / J_33, alpha_2) omega_2 \
  dif / (dif t) vec(omega_2, omega_3) = underbrace(mat(0, alpha_1; alpha_2, 0), A) vec(omega_2, omega_3)
$
For a $2 times 2$ matrix, eigenvalues are
$ lambda^2 - lambda "Tr"(A) + det(A) = 0 ==> lambda^2 = - det(A) \
==> lambda = plus.minus sqrt(alpha_1 alpha_2) ==> "pure imaginary"
$
$==>$ #box(stroke: black, inset: 4pt, baseline: 4pt, [marginally stable (oscillatory)]) \
Oscillatory motion is called "nutation" \
Next we look at the case
$ omega_2 = omega_0 >> omega_1, omega_3 \
alpha_1 = omega_0 (J_22 - J_33) / J_11 \
alpha_2 = omega_0 (J_11 - J_22) / J_33 \
lambda = plus.minus sqrt(alpha_1 alpha_2) $
Here $alpha_1, alpha_2 < 0$ and therefore $lambda$ is real and positive. \
#box(stroke: black, inset: 4pt, baseline: 4pt)[In the absence of energy dissipation, the major and minor axes are stable, while the intermediate axis is unstable.]
== Solutions & Momentum Sphere
- There is an analytic solution to Euler's equation but it is ugly and not very useful.
- Usually we use e.g. Runge-Kutta
- A lot of insight can be gained from looking at qualitative behaviour \
  $norm(h) = "const" ==>$ solutions live on the "momentum sphere" \
  $ T = 1/2 omega^tr J omega = 1/2 h^tr J^(-1) h = "const" ==>$ solutions live on the "energy ellipsoid" \
  $==>$ Trajectories are intersections of these shapes

== Energy Dissipation
The maximum and minimum energy for a given momentum are
  $ norm(h) = "const", #h(1cm) T = 1/2 omega^tr J omega = h^tr J^(-1) h \
    ==> T_max = 1/2 1 / J_11 norm(h)^2, #h(1cm) T_min = 1/2 1 / J_33 norm(h)^2. $
#box(stroke: black, inset: 4pt, baseline: 4pt)[$==>$ If there is energy dissipation, only the major axis is stable since it is the minimum-energy state.]

== Where does energy dissipation come from?
- Fluid slash
- Damping in structural modes
- Magnetic eddy current interactions



