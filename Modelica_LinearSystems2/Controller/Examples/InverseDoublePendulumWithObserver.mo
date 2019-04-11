within Modelica_LinearSystems2.Controller.Examples;
model InverseDoublePendulumWithObserver
  "Example of controlled inverse doubel pendulum"
  extends Modelica.Icons.Example;
  extends Templates.SimpleObserverStateSpaceControl(
    redeclare Components.InverseDoublePendulum3 plant(
      additionalMeasurableOutputs=true,
      m_trolley=1,
      n=6,
      phi2_start=0,
      length=1,
      cartDisturbance=true,
      bodyDisturbance=true,
      l=2,
      secondAngle=false,
      m_load=1,
      phi1_start=1.5707963267949),
    preFilter(
      matrixName="M_pa",
      fileName=DataDir + "inverseDoublePendulumController.mat",
      matrixOnFile=true),
    feedbackMatrix(
      matrixOnFile=true,
      matrixName="K_pa",
      fileName=DataDir + "inverseDoublePendulumController.mat"),
    sampleClock(sampleTime=0.002, blockType=Modelica_LinearSystems2.Controller.Types.BlockType.Continuous),
    observer(
      systemName="stateSpace",
      matrixOnFile=true,
      initType=Types.InitWithGlobalDefault.InitialState,
      methodType=Types.MethodWithGlobalDefault.StepExact,
      x_start={0,0,0,0,0,0},
      observerMatrixName="K_ob2",
      blockType=Types.BlockTypeWithGlobalDefault.UseSampleClockOption,
      withDelay=true,
      fileName=DataDir + "inverseDoublePendulumControllerO.mat"));

  Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    startTime=1,
    width=50,
    period=30,
    amplitude=5)
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Components.AccelerationLimiter accelerationLimiter(
    v_limit=20,
    velocityLimitation=false,
    withDelay2=false,
    a_limit=1)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Noise noise(
    firstSeed={43,123,162},
    blockType=Types.BlockTypeWithGlobalDefault.Discrete,
    y_min=-0.005,
    y_max=0.005,
    sampleFactor=200)
    annotation (Placement(transformation(extent={{130,40},{110,60}})));
  Noise noise1(
    sampleFactor=100,
    blockType=Types.BlockTypeWithGlobalDefault.Discrete,
    y_min=-0.025,
    y_max=0.025)
    annotation (Placement(transformation(extent={{50,40},{70,60}})));

initial equation
  //feedback.y = {0.0};
  // plant.u = {0.0};

equation
  connect(pulse.y, accelerationLimiter.u) annotation (Line(
      points={{-119,0},{-112,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise1.y, plant.dist) annotation (Line(
      points={{71,50},{85.2,50},{85.2,5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise.y, plant.dist2) annotation (Line(
      points={{109,50},{95.4,50},{95.4,5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preFilter.u[1], accelerationLimiter.s) annotation (Line(
      points={{-72,0},{-80,0},{-80,6},{-89,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-100},{140,
            100}}), graphics={Text(
          extent={{44,76},{134,64}},
          lineColor={0,0,0},
          textString="disturbance"), Rectangle(extent={{-76,28},{108,-60}},
            lineColor={255,0,0})}),
    experiment(
      StopTime=60,
      __Dymola_NumberOfIntervals=2000,
      Tolerance=1e-005),
    Documentation(info="<html>
<p>
This example shows a control system with constant state feedback.
The system model of a crane trolles system is taken from [1]. The
feedback matrix and the pre filter can be loaded from MATLAB files.
<!-- The following text was commented by Tobolar (DLR) since the example
cited is still in WorkInProgress (see also documentation source of
other examples of double pendulum):
By default, this files are generated by call of
<a href=\"Modelica_LinearSystems2.WorkInProgress.StateSpace.Examples.designCraneController\">
Examples.StateSpace.designCraneController</a>.
-->
</p>

<h4><a name=\"References\">References</a></h4>
<dl>
<dt>&nbsp;[1] F&ouml;llinger O.:</dt>
<dd> <b>Regelungstechnik</b>.
     H&uuml;thig-Verlag.<br>&nbsp;</dd>
</dl>
</html>"));
end InverseDoublePendulumWithObserver;