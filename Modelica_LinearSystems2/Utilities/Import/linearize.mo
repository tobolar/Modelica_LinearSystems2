within Modelica_LinearSystems2.Utilities.Import;
function linearize "Linearize a model after simulation up to a given time"
  extends Modelica.Icons.Function;

  input String modelName "Name of the Modelica model" annotation(Dialog(__Dymola_translatedModel));
  input Modelica.Units.SI.Time t_linearize=0
    "Simulate until T_linearize and then linearize" annotation (Dialog);

protected
  Modelica_LinearSystems2.StateSpace ss=
    Modelica_LinearSystems2.Internal.stateSpaceOfModel(modelName, t_linearize, t_linearize);

public
  output Real A[:,:] = ss.A "A-matrix";
  output Real B[:,:] = ss.B "B-matrix";
  output Real C[:,:] = ss.C "C-matrix";
  output Real D[:,:] = ss.D "D-matrix";
  output String inputNames[:] = ss.uNames "Modelica names of inputs";
  output String outputNames[:] = ss.yNames "Modelica names of outputs";
  output String stateNames[:] = ss.xNames "Modelica names of states";
algorithm

  annotation (__Dymola_interactive=true, Documentation(info="<html>
<p>
This function initializes a Modelica model and then simulates the model
with its default experiment options until time instant \"t_linearize\".
If t_linearize=0, no simulation takes place (only initialization).
At the simulation stop time, the model is linearized in such a form that
</p>
<ul>
  <li>
    all top-level signals with prefix \"input\" are treated as inputs <strong>u</strong>(t)
    of the model,
  </li>
  <li>
    all top-level signals with prefix \"output\" are treated as outputs <strong>y</strong>(t)
    of the model,
  </li>
  <li>
    all variables that appear differentiated and that are selected as states at this time
    instant are treated as states <strong>x</strong> of the model.
  </li>
</ul>

<p>
Formally, the non-linear hybrid differential-algebraic equation system is therefore treated
as the following ordinary equation system at time instant t_linearize:
</p>
<blockquote><pre>
der(<strong>x</strong>) = <strong>f</strong>(<strong>x</strong>,<strong>u</strong>)
    <strong>y</strong>  = <strong>g</strong>(<strong>x</strong>,<strong>u</strong>) 
</pre></blockquote>
<p>
Taylor series expansion (linearization) of this model around the simulation stop time t_linearize:
</p>
<blockquote><pre>
<strong>u</strong>0 = <strong>u</strong>(t_linearize)
<strong>y</strong>0 = <strong>y</strong>(t_linearize)
<strong>x</strong>0 = <strong>x</strong>(t_linearize)
</pre></blockquote>
<p>
and neglecting higher order terms results in the following system:
</p>
<blockquote><pre>
der(<strong>x</strong>0 + d<strong>x</strong>) = <strong>f</strong>(<strong>x</strong>0,<strong>u</strong>0) + der(<strong>f</strong>,<strong>x</strong>)*d<strong>x</strong> + der(<strong>f</strong>,<strong>u</strong>)*d<strong>u</strong>
    <strong>y</strong>0 + d<strong>y</strong>  = <strong>g</strong>(<strong>x</strong>0,<strong>u</strong>0) + der(<strong>g</strong>,<strong>x</strong>)*d<strong>x</strong> + der(<strong>g</strong>,<strong>u</strong>)*d<strong>u</strong>
</pre></blockquote>
<p>
where der(<strong>f</strong>,<strong>x</strong>) is the partial derivative
of&nbsp;<strong>f</strong> with respect to&nbsp;<strong>x</strong>, and the partial
derivatives are computed at the linearization point t_linearize. Re-ordering of terms
gives (note <strong>der</strong>(<strong>x</strong>0)&nbsp;=&nbsp;<strong>0</strong>):
</p>
<blockquote><pre>
der(d<strong>x</strong>) = der(<strong>f</strong>,<strong>x</strong>)*d<strong>x</strong> + der(<strong>f</strong>,<strong>u</strong>)*d<strong>u</strong> + <strong>f</strong>(<strong>x</strong>0,<strong>u</strong>0)
    d<strong>y</strong>  = der(<strong>g</strong>,<strong>x</strong>)*d<strong>x</strong> + der(<strong>g</strong>,<strong>u</strong>)*d<strong>u</strong> + (<strong>g</strong>(<strong>x</strong>0,<strong>u</strong>0) - <strong>y</strong>0)
</pre></blockquote>
<p>
or
</p>
<blockquote><pre>
der(d<strong>x</strong>) = <strong>A</strong>*d<strong>x</strong> + <strong>B</strong>*d<strong>u</strong> + <strong>f</strong>0
    d<strong>y</strong>  = <strong>C</strong>*d<strong>x</strong> + <strong>D</strong>*d<strong>u</strong>
</pre></blockquote>
<p>
This function returns the matrices&nbsp;<strong>A</strong>, <strong>B</strong>,
<strong>C</strong>, <strong>D</strong> and assumes that the linearization point is
a&nbsp;steady-state point of the simulation (i.e.,
<strong>f</strong>(<strong>x</strong>0,<strong>u</strong>0)&nbsp;=&nbsp;0).
Additionally, the full Modelica names of all inputs, outputs and states shall be
returned if possible (default is to return empty name strings).
</p>
</html>"));
end linearize;
