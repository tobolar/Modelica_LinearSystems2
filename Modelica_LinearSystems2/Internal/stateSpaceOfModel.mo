within Modelica_LinearSystems2.Internal;
function stateSpaceOfModel "Linearize model and generate its state space representation"
  import Modelica_LinearSystems2.StateSpace;

  input String modelName "Name of the Modelica model" annotation(Dialog(__Dymola_translatedModel(translate=true)));
  input Modelica.Units.SI.Time t_linearize=0 "Time of simulation to linearize model";
  input Modelica.Units.SI.Time t_linearizeStop=t_linearize + 1 "End time of model linearization";
  input String fileName="dslin" "Name of the result file without suffix";

protected
  String fileName2 = fileName + ".mat";
  Integer ok = Modelica_LinearSystems2.Internal.simulateAndLinearizeModel(
    modelName, t_linearize, t_linearizeStop, fileName);

  constant StateSpace ss_empty(
    redeclare Real A[0,0] = fill(0, 0, 0),
    redeclare Real B[0,0] = fill(0, 0, 0),
    redeclare Real C[0,0] = fill(0, 0, 0),
    redeclare Real D[0,0] = fill(0, 0, 0));

public
  output Modelica_LinearSystems2.StateSpace ss = if ok==0 then
    Modelica_LinearSystems2.StateSpace.Internal.read_dslin(fileName) else ss_empty
    "Linearized model as StateSpace object";
algorithm

  annotation (
    __Dymola_interactive=true,
    Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
ss = Internal.<strong>stateSpaceOfModel</strong>(modelName, t_linearize, t_linearizeStop, fileName)
</pre></blockquote>

<h4>Description</h4>
<p>
Output state space representation <code>ss</code> of a&nbsp;model <code>modelName</code>
linearized at time <code>t_linearize</code>. The model is first simulated with stop time
<code>t_linearize</code> and subsequently linearized. <code>t_linearizeStop</code> is an optional
end time of linearization.

</p>
</html>"));
end stateSpaceOfModel;
