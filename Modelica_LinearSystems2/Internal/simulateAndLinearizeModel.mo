within Modelica_LinearSystems2.Internal;
function simulateAndLinearizeModel "Run simulation and linearization of a model"
  import DymolaCommands.SimulatorAPI;

  input String modelName "Name of the Modelica model" annotation(Dialog(__Dymola_translatedModel(translate=true)));
  input Modelica.Units.SI.Time t_linearize=0 "Time of simulation to linearize model";
  input Modelica.Units.SI.Time t_linearizeStop(min=t_linearize)=t_linearize + 1
    "End time of model linearization";
  input String fileName="dslin" "Name of the result file without suffix";

  output Integer info "Status: 0 = successful; 1 = linearization failed; 2 = simulation failed";

protected
  String fileName2 = fileName + ".mat";
  Boolean ok;
  constant Integer failLinearization = 1;
  constant Integer failSimulation = 2;
  constant Integer failTranslation = 3;

algorithm
  info := 0;
  if t_linearize > 0 then
    ok := SimulatorAPI.translateModel(modelName);
    if not ok then
      info := failTranslation;
      return;
    end if;

    ok := SimulatorAPI.simulateModel(
      problem=modelName,
      startTime=0,
      stopTime=t_linearize);
    if not ok then
      info := failSimulation;
      return;
    end if;

    ok := SimulatorAPI.importInitial("dsfinal.txt");
  end if;

  ok := SimulatorAPI.linearizeModel(
    problem=modelName,
    resultFile=fileName,
    startTime=t_linearize,
    stopTime=t_linearizeStop);
  if not ok then
    info := failLinearization;
    return;
  end if;

  annotation (
    __Dymola_interactive=true,
    Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
info = Internal.<strong>simulateAndLinearizeModel</strong>(modelName, t_linearize, t_linearizeStop, fileName)
</pre></blockquote>

<h4>Description</h4>
<p>
Simulate a&nbsp;model defined by <code>modelName</code> till <code>t_linearize</code> and
linearize it afterwards with stop time <code>t_linearizeStop</code>.
The system matrix called &quot;ABCD&quot; of the linearized model is saved in the file
<code>fileName.mat</code> which can be loaded for further analysis.
</p>
</html>"));
end simulateAndLinearizeModel;
