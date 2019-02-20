(* ::Package:: *)

BeginPackage["nanowire`"];


Hmu::usage="Hmu[a,\[Mu],V,mumax,sigma,dim]; Hamiltonian for inhomogeneous potential"


wfmajoranamu::usage="wfmajoranamu[a,\[Mu],vz,mumax,sigma,dim,index]; WF for inhomogeneous potential, index for first one or two state(s)"


Hdis::usage="Hdis[a,\[Mu]0,V0,vimp,dim]; Hamiltonian for disorder potential, require  impurity list"


wfmajoranadis::usage="wfmajoranadis[a,\[Mu],vz,vimplist,dim,index]; WF for disorder potential, index for first one or two state(s)"


Hqd::usage="Hqd[a,\[Mu],\[CapitalDelta]0,V,\[Alpha],dim,dotsize,\[Mu]m]; Hamiltonian for quantum dots"


wfmajornanaqd::usage="wfmajoranaqd[a,\[Mu],vz,l0,\[Mu]m,dim,index]; WF for quantum dots, index for first one or two state(s)"


Hsedis::usage="Hsedis[a_,\[Mu]0_,V0_,vimp_,\[Gamma]_,\[Omega]_,dim_]; Hamiltonian for disorder in self energy model"


wfmajoranasedis::usage="wfmajoranasedis[a_,\[Mu]_,vz_,vimp_,\[Gamma]_,\[Omega]_,dim_,index_]; WF for disorder in self energy model"


Hsemu::usage="Hsemu[a_,\[Mu]0_,V0_,mumax_,sigma_,\[Gamma]_,\[Omega]_,Vc_,dim_];Hamiltonian for inhomogenous potential and self energy"


wfmajoranasemu::usage="wfmajoranasemu[a_,\[Mu]_,vz_,mumax_,sigma_,\[Gamma]_,\[Omega]_,Vc_,dim_,index_]; WF for wfmajoranasemu[a_,\[Mu]_,vz_,mumax_,sigma_,\[Gamma]_,\[Omega]_,Vc_,dim_,index_]"


Hseqd::usage="Hseqd[a_,\[Mu]0_,V0_,\[Mu]max_,l0_,\[Gamma]_,\[Omega]_,Vc_,dim_]; Hamiltonian for quantum dots and self energy"


wfmajoranaseqd::usage="wfmajoranaseqd[a_,\[Mu]_,vz_,\[Mu]max_,l0_,\[Gamma]_,\[Omega]_,Vc_,dim_,index_];WF for quantum dots and self energy"


Hmb::usage="Hmb[a,\[Mu],\[CapitalDelta]0,V,\[Alpha],dim]; Hamiltonian for 2-band"


wfmajoranamb::usage="wfmajoranamb[a,\[Mu],vz,dim,index]; WF for 2-band , index for first one to four state(s)"


Hmbdis::usage="Hmbdis[a,\[Mu],\[CapitalDelta]0,V,\[Alpha],vimp,dim]; Hamiltonian for 2-band with disorder potential"


wfmajoranambdis::usage="wfmajoranambdis[a,\[Mu],vz,dim,vimp,index]; WF for 2-band with disorder potential, Hamiltonian for 2-band with disorder potential"


Begin["`Private`"]


errmsg="The length of impurity list `1` does not match with dimension `2`"


Hmu[a_?NumberQ,\[Mu]0_?NumberQ,V0_?NumberQ,mumax_,sigma_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=5/(2 a),Vz=V0,\[CapitalDelta]=.2,peakpos=0.1,mux},mux=mumax Exp[-(#1^2/(2 sigma^2))]+\[Mu]&;KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t (DiagonalMatrix[ConstantArray[1,dim-1],1]+DiagonalMatrix[ConstantArray[1,dim-1],-1])+(2 t) IdentityMatrix[dim]-DiagonalMatrix[mux[Range[dim]]]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] (DiagonalMatrix[ConstantArray[1,dim-1],-1]-DiagonalMatrix[ConstantArray[1,dim-1],1])]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta] IdentityMatrix[dim]]]]


wfmajoranamu[a_,\[Mu]_,vz_,mumax_,sigma_,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,gamma,test,gamma1,gamma2},testp=Transpose[Sort[Select[Transpose[Eigensystem[Hmu[a,\[Mu],vz,mumax,sigma,dim],-10,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[1;;3]]];gamma1=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma2=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hdis[a_?NumberQ,\[Mu]0_?NumberQ,V0_?NumberQ,vimp_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=5/(2 a),Vz=V0,\[CapitalDelta]=.2,mumax=0,peakpos=0.1,sigma=20,mux},mux=\[Mu]-vimp;KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t (DiagonalMatrix[ConstantArray[1,dim-1],1]+DiagonalMatrix[ConstantArray[1,dim-1],-1])+(2 t) IdentityMatrix[dim]-DiagonalMatrix[mux]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] (DiagonalMatrix[ConstantArray[1,dim-1],-1]-DiagonalMatrix[ConstantArray[1,dim-1],1])]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta] IdentityMatrix[dim]]]]


wfmajoranadis::nnarg=errmsg;


wfmajoranadis[a_,\[Mu]_,vz_,vimp_,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,gamma,test,gamma1,gamma2},If[Length[vimp]!=dim,Message[wfmajoranambdis::nnarg,Length[vimp],dim];Throw[$Failed]];testp=Transpose[Sort[Select[Transpose[Eigensystem[Hdis[a,\[Mu],vz,vimp,dim],-20,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[1;;6]]];gamma1=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma2=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hqd[a_?NumberQ,\[Mu]0_?NumberQ,\[CapitalDelta]0_?NumberQ,V0_?NumberQ,\[Alpha]0_?NumberQ,dim0_?IntegerQ,l0_?IntegerQ,\[Mu]m_?NumberQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=\[Alpha]0/(2 a),Vz=V0,\[CapitalDelta]=\[CapitalDelta]0,l=l0,\[CapitalDelta]fun,\[Mu]fun,\[Sigma]=1,\[Mu]max=\[Mu]m,s1,s2,s3,dim=dim0},\[CapitalDelta]list=\[CapitalDelta] UnitStep[Range[dim]-l];\[Mu]list=\[Mu]-\[Mu]max Exp[-(Range[dim]^2/(2*\[Sigma] l^2))];s1=KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[SparseArray[\[Mu]list]]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]];s2=KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]];s3=KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],DiagonalMatrix[SparseArray[\[CapitalDelta]list]]]];(s1+s2)+s3]


wfmajoranaqd[a_,\[Mu]_,vz_,l0_?IntegerQ,\[Mu]m_,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,gamma,test,gamma1,gamma2},testp=Transpose[Sort[Select[Transpose[Eigensystem[Hqd[a,\[Mu],.2,vz,5,dim,l0,\[Mu]m],-10,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[1;;3]]];gamma1=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma2=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2,i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hsedis[a_?NumberQ,\[Mu]0_?NumberQ,V0_?NumberQ,vimp_,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=5/(2 a),Vz=V0,\[CapitalDelta]=.2,mumax=0,peakpos=0.1,sigma=20,mux},mux=\[Mu]-vimp;\[CapitalDelta]=\[CapitalDelta] Sqrt[1-(V0/Vc)^2];KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[SparseArray[mux]]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]-\[Gamma] Re[(\[Omega] IdentityMatrix[4 dim,SparseArray])/Sqrt[\[CapitalDelta]^2-\[Omega]^2-I/10^9]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[IdentityMatrix[2],(\[CapitalDelta] IdentityMatrix[dim,SparseArray])/Sqrt[\[CapitalDelta]^2-\[Omega]^2-I/10^9]]]]]


wfmajoranasedis::nnarg=errmsg;


wfmajoranasedis[a_,\[Mu]_,vz_,vimp_,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ,index_]:=Block[{testp,testn,g,gamma,test,gamma1,gamma2},If[Length[vimp]!=dim,Message[wfmajoranasedis::nnarg,Length[vimp],dim];Throw[$Failed]];g=Table[testp=Sort[Select[Transpose[Eigensystem[Hsedis[a,\[Mu],vz,vimp,\[Gamma],\[Omega][[i]],Vc,dim],-6,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[i]];gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2]];{Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]]},{i,index}];gamma1=g[[All,1]];gamma2=g[[All,2]];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hsemu[a_?NumberQ,\[Mu]0_?NumberQ,V0_?NumberQ,mumax_,sigma_,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=5/(2 a),Vz=V0,\[CapitalDelta]=.2,mux},mux=mumax Exp[-(#1^2/(2 sigma^2))]+\[Mu]&;\[CapitalDelta]=\[CapitalDelta] Sqrt[1-(V0/Vc)^2];KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[SparseArray[mux[Range[dim]]]]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]-\[Gamma] Re[(\[Omega] IdentityMatrix[4 dim,SparseArray])/Sqrt[\[CapitalDelta]^2-\[Omega]^2-I/10^9]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[IdentityMatrix[2],(\[CapitalDelta] IdentityMatrix[dim,SparseArray])/Sqrt[\[CapitalDelta]^2-\[Omega]^2-I/10^9]]]]]


wfmajoranasemu[a_,\[Mu]_,vz_,mumax_,sigma_,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,g,gamma,test,gamma1,gamma2},g=Table[testp=Sort[Select[Transpose[Eigensystem[Hsemu[a,\[Mu],vz,mumax,sigma,\[Gamma],\[Omega][[i]],Vc,dim],-6,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[i]];gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2]];{Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]]},{i,index}];gamma1=g[[All,1]];gamma2=g[[All,2]];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hseqd[a_?NumberQ,\[Mu]0_?NumberQ,V0_?NumberQ,\[Mu]max_,l0_?IntegerQ,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=5/(2 a),Vz=V0,\[CapitalDelta]=.2,(*\[Mu]list,\[CapitalDelta]list,*)l=l0,\[Sigma]=1},\[CapitalDelta]list=SparseArray[DiagonalMatrix[\[CapitalDelta] UnitStep[Range[dim]-l]]];\[Mu]list=\[Mu]-\[Mu]max Exp[-(Range[dim]^2/(2\[Sigma] l^2))];\[CapitalDelta]=\[CapitalDelta] Sqrt[1-(V0/Vc)^2];KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[SparseArray[\[Mu]list]]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]-\[Gamma] Re[KroneckerProduct[IdentityMatrix[4,SparseArray],\[Omega] /Sqrt[\[CapitalDelta]list^2-\[Omega]^2-I/10^9]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[IdentityMatrix[2],\[CapitalDelta]list/Sqrt[\[CapitalDelta]list^2-\[Omega]^2-I/10^9]]]]]


wfmajoranaseqd[a_,\[Mu]_,vz_,\[Mu]max_,l0_?IntegerQ,\[Gamma]_,\[Omega]_,Vc_,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,g,gamma,test,gamma1,gamma2},g=Table[testp=Sort[Select[Transpose[Eigensystem[Hseqd[a,\[Mu],vz,\[Mu]max,l0,\[Gamma],\[Omega][[i]],Vc,dim],-10,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[i]];gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].testp[[2]];{Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]]},{i,index}];gamma1=g[[All,1]];gamma2=g[[All,2]];ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma1,gamma2}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,Filling->Axis,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\)","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\)"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->{Blue,Cyan,Red,Orange}]]


Hmb[a_?NumberQ,\[Mu]0_?NumberQ,\[CapitalDelta]0_?NumberQ,V0_?NumberQ,\[Alpha]0_?NumberQ,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=\[Alpha]0/(2 a),Vz=V0,\[CapitalDelta]11=\[CapitalDelta]0,\[CapitalDelta]12=\[CapitalDelta]0,H11,H12,H22,\[Epsilon]=0.75},H11=KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(-\[Mu]+2 t) IdentityMatrix[dim,SparseArray]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]11 IdentityMatrix[dim,SparseArray]]];H22=KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(\[Epsilon]-\[Mu]+2 t) IdentityMatrix[dim,SparseArray]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]11 IdentityMatrix[dim,SparseArray]]];H12=KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]12 IdentityMatrix[dim,SparseArray]]];Chop[ArrayFlatten[{{H11,H12},{H12,H22}}]]]


wfmajoranamb[a_?NumberQ,\[Mu]_?NumberQ,vz_?NumberQ,dim_?IntegerQ,index_?IntegerQ]:=Block[{testp,testn,gamma,test,gamma11,gamma12,gamma21,gamma22},If[Length[vimp]!=dim,Message[wfmajoranambdis::nnarg,Length[vimp],dim];Throw[$Failed]];testp=Transpose[Sort[Select[Transpose[Eigensystem[Hmb[a,\[Mu],.2,vz,5,dim],-10,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[1;;4]]];test1=testp[[2,All,1;;4 dim]];test2=testp[[2,All,4 dim+1;;8 dim]];gamma11=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test1[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma12=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test1[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];gamma21=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test2[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma22=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test2[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];Grid[{{ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma11,gamma12}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->(Directive[Thin,#1]&)/@{Blue,Cyan,Red,Orange,Pink,Green,LightRed,Purple},ImageSize->Medium],ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma21,gamma22}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->(Directive[Thin,#1]&)/@{Blue,Cyan,Red,Orange,Pink,Green,LightRed,Purple},ImageSize->Medium]}}]]


Hmbdis[a_?NumberQ,\[Mu]0_?NumberQ,\[CapitalDelta]0_?NumberQ,V0_?NumberQ,\[Alpha]0_?NumberQ,vimp_,dim_?IntegerQ]:=Block[{t=25/a^2,\[Mu]=\[Mu]0,\[Alpha]=\[Alpha]0/(2 a),Vz=V0,\[CapitalDelta]11=\[CapitalDelta]0,\[CapitalDelta]12=\[CapitalDelta]0,H11,H12,H22,\[Epsilon]=1,mux},mux=\[Mu]-vimp;H11=KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(+2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[mux]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]11 IdentityMatrix[dim,SparseArray]]];H22=KroneckerProduct[PauliMatrix[3],KroneckerProduct[PauliMatrix[0],-t SparseArray[{Band[{1,2}]->1,Band[{2,1}]->1},{dim,dim}]+(\[Epsilon]+2 t) IdentityMatrix[dim,SparseArray]-DiagonalMatrix[mux]]+KroneckerProduct[PauliMatrix[2],I \[Alpha] SparseArray[{Band[{1,2}]->-1,Band[{2,1}]->1},{dim,dim}]]]+KroneckerProduct[PauliMatrix[0],KroneckerProduct[PauliMatrix[3],Vz IdentityMatrix[dim,SparseArray]]]+KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]11 IdentityMatrix[dim,SparseArray]]];H12=KroneckerProduct[PauliMatrix[1],KroneckerProduct[PauliMatrix[0],\[CapitalDelta]12 IdentityMatrix[dim,SparseArray]]];Chop[ArrayFlatten[{{H11,H12},{H12,H22}}]]]


wfmajoranambdis::nnarg=errmsg;


wfmajoranambdis[a_?NumberQ,\[Mu]_?NumberQ,vz_?NumberQ,dim_?IntegerQ,vimp_,index_?IntegerQ]:=Block[{testp,testn,gamma,test,gamma11,gamma12,gamma21,gamma22},If[Length[vimp]!=dim,Message[wfmajoranambdis::nnarg,Length[vimp],dim];Throw[$Failed]];testp=Transpose[Sort[Select[Transpose[Eigensystem[Hmbdis[a,\[Mu],.2,vz,5,vimp,dim],-10,Method->{"Arnoldi","Criteria"->"Magnitude","MaxIterations"->\[Infinity]}]],#1[[1]]>0&],#1[[1]]<#2[[1]]&][[1;;4]]];test1=testp[[2,All,1;;4 dim]];test2=testp[[2,All,4 dim+1;;8 dim]];gamma11=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test1[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma12=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test1[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];gamma21=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test2[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{1,3}]]],{i,index}];gamma22=Table[gamma=KroneckerProduct[1/2 ConjugateTranspose[{{1,I,0,0},{0,0,1,I},{0,0,1,-I},{-1,I,0,0}}],IdentityMatrix[dim,SparseArray]].test2[[i]];Total[ArrayReshape[Abs[gamma]^2,{4,dim}][[{2,4}]]],{i,index}];Grid[{{ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma11,gamma12}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) L","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) L"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->(Directive[Thin,#1]&)/@{Blue,Cyan,Red,Orange,Pink,Green,LightRed,Purple},ImageSize->Medium],ListLinePlot[Flatten[Transpose[ArrayFlatten[{gamma21,gamma22}]],1],DataRange->{0,(dim a)/100},PlotLabel->"\!\(\*SubscriptBox[\(V\), \(Z\)]\)="<>ToString[vz]<>"(meV)",PlotRange->Full,Frame->True,PlotLegends->Placed[SwatchLegend[{"1st \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","1st \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","2nd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","3rd \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(1\)]\) H","4th \!\(\*SubscriptBox[\(\[Gamma]\), \(2\)]\) H"}],Top],FrameLabel->{"x(\[Mu]m)",""},PlotStyle->(Directive[Thin,#1]&)/@{Blue,Cyan,Red,Orange,Pink,Green,LightRed,Purple},ImageSize->Medium]}}]]


End[];


EndPackage[];
