/*
 * Copyright (c) 2003, 2007-14 Matteo Frigo
 * Copyright (c) 2003, 2007-14 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

/* This file was automatically generated --- DO NOT EDIT */
/* Generated on Thu Dec 15 14:15:57 EST 2016 */

#include "codelet-dft.h"

#ifdef HAVE_FMA

/* Generated by: ../../../genfft/gen_notw.native -fma -reorder-insns -schedule-for-pipeline -compact -variables 4 -standalone -pipeline-latency 4 -n 25 -name n1_25 -include n.h */

/*
 * This function contains 352 FP additions, 268 FP multiplications,
 * (or, 84 additions, 0 multiplications, 268 fused multiply/add),
 * 164 stack variables, 47 constants, and 100 memory accesses
 */
#include "n.h"

void n1_25(const R *ri, const R *ii, R *ro, R *io, stride is, stride os, INT v, INT ivs, INT ovs)
{
     DK(KP803003575, +0.803003575438660414833440593570376004635464850);
     DK(KP554608978, +0.554608978404018097464974850792216217022558774);
     DK(KP248028675, +0.248028675328619457762448260696444630363259177);
     DK(KP726211448, +0.726211448929902658173535992263577167607493062);
     DK(KP525970792, +0.525970792408939708442463226536226366643874659);
     DK(KP992114701, +0.992114701314477831049793042785778521453036709);
     DK(KP851038619, +0.851038619207379630836264138867114231259902550);
     DK(KP912575812, +0.912575812670962425556968549836277086778922727);
     DK(KP912018591, +0.912018591466481957908415381764119056233607330);
     DK(KP943557151, +0.943557151597354104399655195398983005179443399);
     DK(KP614372930, +0.614372930789563808870829930444362096004872855);
     DK(KP621716863, +0.621716863012209892444754556304102309693593202);
     DK(KP994076283, +0.994076283785401014123185814696322018529298887);
     DK(KP734762448, +0.734762448793050413546343770063151342619912334);
     DK(KP772036680, +0.772036680810363904029489473607579825330539880);
     DK(KP126329378, +0.126329378446108174786050455341811215027378105);
     DK(KP827271945, +0.827271945972475634034355757144307982555673741);
     DK(KP949179823, +0.949179823508441261575555465843363271711583843);
     DK(KP860541664, +0.860541664367944677098261680920518816412804187);
     DK(KP557913902, +0.557913902031834264187699648465567037992437152);
     DK(KP249506682, +0.249506682107067890488084201715862638334226305);
     DK(KP681693190, +0.681693190061530575150324149145440022633095390);
     DK(KP560319534, +0.560319534973832390111614715371676131169633784);
     DK(KP998026728, +0.998026728428271561952336806863450553336905220);
     DK(KP906616052, +0.906616052148196230441134447086066874408359177);
     DK(KP968479752, +0.968479752739016373193524836781420152702090879);
     DK(KP845997307, +0.845997307939530944175097360758058292389769300);
     DK(KP470564281, +0.470564281212251493087595091036643380879947982);
     DK(KP062914667, +0.062914667253649757225485955897349402364686947);
     DK(KP921177326, +0.921177326965143320250447435415066029359282231);
     DK(KP833417178, +0.833417178328688677408962550243238843138996060);
     DK(KP541454447, +0.541454447536312777046285590082819509052033189);
     DK(KP242145790, +0.242145790282157779872542093866183953459003101);
     DK(KP683113946, +0.683113946453479238701949862233725244439656928);
     DK(KP559154169, +0.559154169276087864842202529084232643714075927);
     DK(KP968583161, +0.968583161128631119490168375464735813836012403);
     DK(KP904730450, +0.904730450839922351881287709692877908104763647);
     DK(KP831864738, +0.831864738706457140726048799369896829771167132);
     DK(KP871714437, +0.871714437527667770979999223229522602943903653);
     DK(KP939062505, +0.939062505817492352556001843133229685779824606);
     DK(KP549754652, +0.549754652192770074288023275540779861653779767);
     DK(KP634619297, +0.634619297544148100711287640319130485732531031);
     DK(KP256756360, +0.256756360367726783319498520922669048172391148);
     DK(KP951056516, +0.951056516295153572116439333379382143405698634);
     DK(KP559016994, +0.559016994374947424102293417182819058860154590);
     DK(KP250000000, +0.250000000000000000000000000000000000000000000);
     DK(KP618033988, +0.618033988749894848204586834365638117720309180);
     {
	  INT i;
	  for (i = v; i > 0; i = i - 1, ri = ri + ivs, ii = ii + ivs, ro = ro + ovs, io = io + ovs, MAKE_VOLATILE_STRIDE(100, is), MAKE_VOLATILE_STRIDE(100, os)) {
	       E T3Y, T3U, T3W, T42, T44, T3X, T3R, T3V, T3Z, T43;
	       {
		    E T4Q, T1U, T9, T3b, T45, T3e, T46, T1D, T4P, T1R, Ts, T1K, T18, T1E, T4z;
		    E T5f, T3z, T22, T4s, T5b, T3C, T2o, T3D, T2h, T4p, T5c, T4w, T5e, T3A, T29;
		    E T2z, T2y, TL, T1L, T1r, T1F, T4a, T57, T3v, T2x, T4k, T55, T3s, T2T, T2D;
		    E T4c, T3t, T2M, T4h, T54, T1v, T1C, T1Q;
		    {
			 E T1, T2, T3, T5, T6;
			 T1 = ri[0];
			 T2 = ri[WS(is, 5)];
			 T3 = ri[WS(is, 20)];
			 T5 = ri[WS(is, 10)];
			 T6 = ri[WS(is, 15)];
			 {
			      E T3a, T3c, T1y, T1z, T1A, T39, T4, T1S, T1B, T3d;
			      T1v = ii[0];
			      T4 = T2 + T3;
			      T1S = T2 - T3;
			      {
				   E T7, T1T, T8, T1w, T1x;
				   T7 = T5 + T6;
				   T1T = T5 - T6;
				   T1w = ii[WS(is, 5)];
				   T1x = ii[WS(is, 20)];
				   T4Q = FNMS(KP618033988, T1S, T1T);
				   T1U = FMA(KP618033988, T1T, T1S);
				   T8 = T4 + T7;
				   T3a = T4 - T7;
				   T3c = T1w - T1x;
				   T1y = T1w + T1x;
				   T1z = ii[WS(is, 10)];
				   T1A = ii[WS(is, 15)];
				   T39 = FNMS(KP250000000, T8, T1);
				   T9 = T1 + T8;
			      }
			      T1B = T1z + T1A;
			      T3d = T1z - T1A;
			      T3b = FMA(KP559016994, T3a, T39);
			      T45 = FNMS(KP559016994, T3a, T39);
			      T3e = FMA(KP618033988, T3d, T3c);
			      T46 = FNMS(KP618033988, T3c, T3d);
			      T1C = T1y + T1B;
			      T1Q = T1y - T1B;
			 }
		    }
		    {
			 E T24, T23, T28, T4v;
			 {
			      E Ta, TQ, Tj, TZ, T1Z, T20, Th, T26, T27, T1X, TX, T2l, T2m, Tq, T2c;
			      E T2e, T12, T15, T2f, T1P, TT, TW;
			      Ta = ri[WS(is, 1)];
			      T1P = FNMS(KP250000000, T1C, T1v);
			      T1D = T1v + T1C;
			      TQ = ii[WS(is, 1)];
			      Tj = ri[WS(is, 4)];
			      T4P = FNMS(KP559016994, T1Q, T1P);
			      T1R = FMA(KP559016994, T1Q, T1P);
			      TZ = ii[WS(is, 4)];
			      {
				   E Tb, Tc, Te, Tf;
				   Tb = ri[WS(is, 6)];
				   Tc = ri[WS(is, 21)];
				   Te = ri[WS(is, 11)];
				   Tf = ri[WS(is, 16)];
				   {
					E TR, Td, Tg, TS, TU, TV;
					TR = ii[WS(is, 6)];
					T1Z = Tc - Tb;
					Td = Tb + Tc;
					T20 = Tf - Te;
					Tg = Te + Tf;
					TS = ii[WS(is, 21)];
					TU = ii[WS(is, 11)];
					TV = ii[WS(is, 16)];
					Th = Td + Tg;
					T24 = Td - Tg;
					T26 = TR - TS;
					TT = TR + TS;
					TW = TU + TV;
					T27 = TV - TU;
				   }
			      }
			      {
				   E Tk, Tl, Tn, To;
				   Tk = ri[WS(is, 9)];
				   T1X = TT - TW;
				   TX = TT + TW;
				   Tl = ri[WS(is, 24)];
				   Tn = ri[WS(is, 14)];
				   To = ri[WS(is, 19)];
				   {
					E T10, Tm, Tp, T11, T13, T14;
					T10 = ii[WS(is, 9)];
					T2l = Tl - Tk;
					Tm = Tk + Tl;
					T2m = To - Tn;
					Tp = Tn + To;
					T11 = ii[WS(is, 24)];
					T13 = ii[WS(is, 14)];
					T14 = ii[WS(is, 19)];
					Tq = Tm + Tp;
					T2c = Tm - Tp;
					T2e = T11 - T10;
					T12 = T10 + T11;
					T15 = T13 + T14;
					T2f = T14 - T13;
				   }
			      }
			      {
				   E T2j, T2b, T1W, T21, T4y, T2i;
				   {
					E Ti, T16, Tr, TY, T17;
					T23 = FNMS(KP250000000, Th, Ta);
					Ti = Ta + Th;
					T2j = T15 - T12;
					T16 = T12 + T15;
					Tr = Tj + Tq;
					T2b = FMS(KP250000000, Tq, Tj);
					T1W = FNMS(KP250000000, TX, TQ);
					TY = TQ + TX;
					T21 = FMA(KP618033988, T20, T1Z);
					T4y = FNMS(KP618033988, T1Z, T20);
					T2i = FNMS(KP250000000, T16, TZ);
					T17 = TZ + T16;
					Ts = Ti + Tr;
					T1K = Ti - Tr;
					T18 = TY - T17;
					T1E = TY + T17;
				   }
				   {
					E T2n, T4r, T4x, T1Y;
					T2n = FMA(KP618033988, T2m, T2l);
					T4r = FNMS(KP618033988, T2l, T2m);
					T4x = FNMS(KP559016994, T1X, T1W);
					T1Y = FMA(KP559016994, T1X, T1W);
					{
					     E T4o, T2g, T2d, T4n, T4q, T2k;
					     T4o = FNMS(KP618033988, T2e, T2f);
					     T2g = FMA(KP618033988, T2f, T2e);
					     T4z = FMA(KP951056516, T4y, T4x);
					     T5f = FNMS(KP951056516, T4y, T4x);
					     T3z = FNMS(KP951056516, T21, T1Y);
					     T22 = FMA(KP951056516, T21, T1Y);
					     T4q = FMA(KP559016994, T2j, T2i);
					     T2k = FNMS(KP559016994, T2j, T2i);
					     T4s = FMA(KP951056516, T4r, T4q);
					     T5b = FNMS(KP951056516, T4r, T4q);
					     T3C = FNMS(KP951056516, T2n, T2k);
					     T2o = FMA(KP951056516, T2n, T2k);
					     T2d = FNMS(KP559016994, T2c, T2b);
					     T4n = FMA(KP559016994, T2c, T2b);
					     T28 = FNMS(KP618033988, T27, T26);
					     T4v = FMA(KP618033988, T26, T27);
					     T3D = FNMS(KP951056516, T2g, T2d);
					     T2h = FMA(KP951056516, T2g, T2d);
					     T4p = FMA(KP951056516, T4o, T4n);
					     T5c = FNMS(KP951056516, T4o, T4n);
					}
				   }
			      }
			 }
			 {
			      E Tt, T19, TC, T1i, T2u, T2v, TA, T2B, T2C, T2s, T1g, T2J, T2K, TJ, T2O;
			      E T2Q, T1l, T1o, T2R;
			      {
				   E T4u, T25, T1c, T1f;
				   Tt = ri[WS(is, 2)];
				   T19 = ii[WS(is, 2)];
				   TC = ri[WS(is, 3)];
				   T4u = FNMS(KP559016994, T24, T23);
				   T25 = FMA(KP559016994, T24, T23);
				   T1i = ii[WS(is, 3)];
				   {
					E Tu, Tv, Tx, Ty;
					Tu = ri[WS(is, 7)];
					T4w = FNMS(KP951056516, T4v, T4u);
					T5e = FMA(KP951056516, T4v, T4u);
					T3A = FNMS(KP951056516, T28, T25);
					T29 = FMA(KP951056516, T28, T25);
					Tv = ri[WS(is, 22)];
					Tx = ri[WS(is, 12)];
					Ty = ri[WS(is, 17)];
					{
					     E T1a, Tw, Tz, T1b, T1d, T1e;
					     T1a = ii[WS(is, 7)];
					     T2u = Tv - Tu;
					     Tw = Tu + Tv;
					     T2v = Ty - Tx;
					     Tz = Tx + Ty;
					     T1b = ii[WS(is, 22)];
					     T1d = ii[WS(is, 12)];
					     T1e = ii[WS(is, 17)];
					     TA = Tw + Tz;
					     T2z = Tz - Tw;
					     T2B = T1b - T1a;
					     T1c = T1a + T1b;
					     T1f = T1d + T1e;
					     T2C = T1d - T1e;
					}
				   }
				   {
					E TD, TE, TG, TH;
					TD = ri[WS(is, 8)];
					T2s = T1f - T1c;
					T1g = T1c + T1f;
					TE = ri[WS(is, 23)];
					TG = ri[WS(is, 13)];
					TH = ri[WS(is, 18)];
					{
					     E T1j, TF, TI, T1k, T1m, T1n;
					     T1j = ii[WS(is, 8)];
					     T2J = TD - TE;
					     TF = TD + TE;
					     T2K = TG - TH;
					     TI = TG + TH;
					     T1k = ii[WS(is, 23)];
					     T1m = ii[WS(is, 13)];
					     T1n = ii[WS(is, 18)];
					     TJ = TF + TI;
					     T2O = TI - TF;
					     T2Q = T1k - T1j;
					     T1l = T1j + T1k;
					     T1o = T1m + T1n;
					     T2R = T1n - T1m;
					}
				   }
			      }
			      {
				   E T2H, T2N, T2r, T2w, T49, T2G;
				   {
					E TB, T1p, TK, T1h, T1q;
					T2y = FNMS(KP250000000, TA, Tt);
					TB = Tt + TA;
					T2H = T1o - T1l;
					T1p = T1l + T1o;
					TK = TC + TJ;
					T2N = FNMS(KP250000000, TJ, TC);
					T2r = FNMS(KP250000000, T1g, T19);
					T1h = T19 + T1g;
					T2w = FMA(KP618033988, T2v, T2u);
					T49 = FNMS(KP618033988, T2u, T2v);
					T2G = FNMS(KP250000000, T1p, T1i);
					T1q = T1i + T1p;
					TL = TB + TK;
					T1L = TB - TK;
					T1r = T1h - T1q;
					T1F = T1h + T1q;
				   }
				   {
					E T2S, T4j, T48, T2t;
					T2S = FMA(KP618033988, T2R, T2Q);
					T4j = FNMS(KP618033988, T2Q, T2R);
					T48 = FMA(KP559016994, T2s, T2r);
					T2t = FNMS(KP559016994, T2s, T2r);
					{
					     E T4g, T2L, T2I, T4f, T4i, T2P;
					     T4g = FNMS(KP618033988, T2J, T2K);
					     T2L = FMA(KP618033988, T2K, T2J);
					     T4a = FMA(KP951056516, T49, T48);
					     T57 = FNMS(KP951056516, T49, T48);
					     T3v = FNMS(KP951056516, T2w, T2t);
					     T2x = FMA(KP951056516, T2w, T2t);
					     T4i = FMA(KP559016994, T2O, T2N);
					     T2P = FNMS(KP559016994, T2O, T2N);
					     T4k = FNMS(KP951056516, T4j, T4i);
					     T55 = FMA(KP951056516, T4j, T4i);
					     T3s = FMA(KP951056516, T2S, T2P);
					     T2T = FNMS(KP951056516, T2S, T2P);
					     T2I = FNMS(KP559016994, T2H, T2G);
					     T4f = FMA(KP559016994, T2H, T2G);
					     T2D = FNMS(KP618033988, T2C, T2B);
					     T4c = FMA(KP618033988, T2B, T2C);
					     T3t = FMA(KP951056516, T2L, T2I);
					     T2M = FNMS(KP951056516, T2L, T2I);
					     T4h = FNMS(KP951056516, T4g, T4f);
					     T54 = FMA(KP951056516, T4g, T4f);
					}
				   }
			      }
			 }
		    }
		    {
			 E T4d, T58, T3w, T3H, T3r, T3k, T36, T38, T3o, T3q, T3j, T2Z, T37;
			 {
			      E T2E, T1s, T1u, TP, T1t;
			      {
				   E TM, TO, TN, T4b, T2A;
				   TM = Ts + TL;
				   TO = Ts - TL;
				   T4b = FMA(KP559016994, T2z, T2y);
				   T2A = FNMS(KP559016994, T2z, T2y);
				   TN = FNMS(KP250000000, TM, T9);
				   T4d = FMA(KP951056516, T4c, T4b);
				   T58 = FNMS(KP951056516, T4c, T4b);
				   T3w = FMA(KP951056516, T2D, T2A);
				   T2E = FNMS(KP951056516, T2D, T2A);
				   T1s = FMA(KP618033988, T1r, T18);
				   T1u = FNMS(KP618033988, T18, T1r);
				   ro[0] = T9 + TM;
				   TP = FMA(KP559016994, TO, TN);
				   T1t = FNMS(KP559016994, TO, TN);
			      }
			      {
				   E T1J, T1N, T1M, T1O, T1G, T1I, T1H;
				   T1G = T1E + T1F;
				   T1I = T1E - T1F;
				   ro[WS(os, 15)] = FMA(KP951056516, T1u, T1t);
				   ro[WS(os, 10)] = FNMS(KP951056516, T1u, T1t);
				   ro[WS(os, 5)] = FMA(KP951056516, T1s, TP);
				   ro[WS(os, 20)] = FNMS(KP951056516, T1s, TP);
				   T1H = FNMS(KP250000000, T1G, T1D);
				   io[0] = T1D + T1G;
				   T1J = FMA(KP559016994, T1I, T1H);
				   T1N = FNMS(KP559016994, T1I, T1H);
				   T1M = FMA(KP618033988, T1L, T1K);
				   T1O = FNMS(KP618033988, T1K, T1L);
				   {
					E T1V, T3f, T3m, T3n, T2W, T2Y, T32, T3g, T3h, T35, T3i, T2X;
					T3H = FMA(KP951056516, T1U, T1R);
					T1V = FNMS(KP951056516, T1U, T1R);
					T3f = FMA(KP951056516, T3e, T3b);
					T3r = FNMS(KP951056516, T3e, T3b);
					io[WS(os, 15)] = FNMS(KP951056516, T1O, T1N);
					io[WS(os, 10)] = FMA(KP951056516, T1O, T1N);
					io[WS(os, 20)] = FMA(KP951056516, T1M, T1J);
					io[WS(os, 5)] = FNMS(KP951056516, T1M, T1J);
					{
					     E T30, T2a, T2p, T31, T33, T2F, T2U, T34, T2q, T2V;
					     T30 = FMA(KP256756360, T22, T29);
					     T2a = FNMS(KP256756360, T29, T22);
					     T2p = FMA(KP634619297, T2o, T2h);
					     T31 = FNMS(KP634619297, T2h, T2o);
					     T33 = FMA(KP549754652, T2x, T2E);
					     T2F = FNMS(KP549754652, T2E, T2x);
					     T2U = FNMS(KP939062505, T2T, T2M);
					     T34 = FMA(KP939062505, T2M, T2T);
					     T3m = FNMS(KP871714437, T2p, T2a);
					     T2q = FMA(KP871714437, T2p, T2a);
					     T3n = FNMS(KP831864738, T2U, T2F);
					     T2V = FMA(KP831864738, T2U, T2F);
					     T2W = FMA(KP904730450, T2V, T2q);
					     T2Y = FNMS(KP904730450, T2V, T2q);
					     T32 = FNMS(KP871714437, T31, T30);
					     T3g = FMA(KP871714437, T31, T30);
					     T3h = FMA(KP831864738, T34, T33);
					     T35 = FNMS(KP831864738, T34, T33);
					}
					io[WS(os, 1)] = FMA(KP968583161, T2W, T1V);
					T3i = FMA(KP904730450, T3h, T3g);
					T3k = FNMS(KP904730450, T3h, T3g);
					T36 = FMA(KP559154169, T35, T32);
					T38 = FNMS(KP683113946, T32, T35);
					ro[WS(os, 1)] = FMA(KP968583161, T3i, T3f);
					T2X = FNMS(KP242145790, T2W, T1V);
					T3o = FMA(KP559154169, T3n, T3m);
					T3q = FNMS(KP683113946, T3m, T3n);
					T3j = FNMS(KP242145790, T3i, T3f);
					T2Z = FMA(KP541454447, T2Y, T2X);
					T37 = FNMS(KP541454447, T2Y, T2X);
				   }
			      }
			 }
			 {
			      E T47, T4R, T5A, T5w, T5y, T5E, T5G, T5z, T5t, T5x;
			      {
				   E T53, T5j, T5u, T5v, T5i, T5D, T5m, T5p, T5C, T3p, T3l, T5s, T5q, T5r;
				   T47 = FMA(KP951056516, T46, T45);
				   T53 = FNMS(KP951056516, T46, T45);
				   T3p = FNMS(KP541454447, T3k, T3j);
				   T3l = FMA(KP541454447, T3k, T3j);
				   io[WS(os, 16)] = FNMS(KP833417178, T38, T37);
				   io[WS(os, 11)] = FMA(KP833417178, T38, T37);
				   io[WS(os, 21)] = FMA(KP921177326, T36, T2Z);
				   io[WS(os, 6)] = FNMS(KP921177326, T36, T2Z);
				   ro[WS(os, 11)] = FNMS(KP833417178, T3q, T3p);
				   ro[WS(os, 16)] = FMA(KP833417178, T3q, T3p);
				   ro[WS(os, 21)] = FNMS(KP921177326, T3o, T3l);
				   ro[WS(os, 6)] = FMA(KP921177326, T3o, T3l);
				   T5j = FMA(KP951056516, T4Q, T4P);
				   T4R = FNMS(KP951056516, T4Q, T4P);
				   {
					E T5k, T56, T59, T5l, T5n, T5d, T5g, T5o, T5a, T5h;
					T5k = FNMS(KP062914667, T54, T55);
					T56 = FMA(KP062914667, T55, T54);
					T59 = FMA(KP634619297, T58, T57);
					T5l = FNMS(KP634619297, T57, T58);
					T5n = FNMS(KP470564281, T5b, T5c);
					T5d = FMA(KP470564281, T5c, T5b);
					T5g = FMA(KP549754652, T5f, T5e);
					T5o = FNMS(KP549754652, T5e, T5f);
					T5u = FNMS(KP845997307, T59, T56);
					T5a = FMA(KP845997307, T59, T56);
					T5v = FNMS(KP968479752, T5g, T5d);
					T5h = FMA(KP968479752, T5g, T5d);
					T5i = FMA(KP906616052, T5h, T5a);
					T5A = FNMS(KP906616052, T5h, T5a);
					T5D = FNMS(KP845997307, T5l, T5k);
					T5m = FMA(KP845997307, T5l, T5k);
					T5p = FMA(KP968479752, T5o, T5n);
					T5C = FNMS(KP968479752, T5o, T5n);
				   }
				   ro[WS(os, 2)] = FMA(KP998026728, T5i, T53);
				   T5s = FMA(KP906616052, T5p, T5m);
				   T5q = FNMS(KP906616052, T5p, T5m);
				   T5w = FNMS(KP560319534, T5v, T5u);
				   T5y = FMA(KP681693190, T5u, T5v);
				   T5E = FNMS(KP681693190, T5D, T5C);
				   T5G = FMA(KP560319534, T5C, T5D);
				   T5r = FMA(KP249506682, T5q, T5j);
				   io[WS(os, 2)] = FNMS(KP998026728, T5q, T5j);
				   T5z = FNMS(KP249506682, T5i, T53);
				   T5t = FNMS(KP557913902, T5s, T5r);
				   T5x = FMA(KP557913902, T5s, T5r);
			      }
			      {
				   E T4W, T4M, T4O, T50, T52, T4V, T4F, T4N;
				   {
					E T4Y, T4Z, T4C, T4E, T4I, T4T, T4S, T4L, T5F, T5B, T4U, T4D;
					T5F = FMA(KP557913902, T5A, T5z);
					T5B = FNMS(KP557913902, T5A, T5z);
					io[WS(os, 7)] = FMA(KP860541664, T5y, T5x);
					io[WS(os, 22)] = FNMS(KP860541664, T5y, T5x);
					io[WS(os, 17)] = FMA(KP949179823, T5w, T5t);
					io[WS(os, 12)] = FNMS(KP949179823, T5w, T5t);
					ro[WS(os, 12)] = FNMS(KP949179823, T5G, T5F);
					ro[WS(os, 17)] = FMA(KP949179823, T5G, T5F);
					ro[WS(os, 7)] = FNMS(KP860541664, T5E, T5B);
					ro[WS(os, 22)] = FMA(KP860541664, T5E, T5B);
					{
					     E T4J, T4e, T4l, T4K, T4G, T4t, T4A, T4H, T4m, T4B;
					     T4J = FNMS(KP062914667, T4a, T4d);
					     T4e = FMA(KP062914667, T4d, T4a);
					     T4l = FNMS(KP827271945, T4k, T4h);
					     T4K = FMA(KP827271945, T4h, T4k);
					     T4G = FNMS(KP126329378, T4p, T4s);
					     T4t = FMA(KP126329378, T4s, T4p);
					     T4A = FMA(KP939062505, T4z, T4w);
					     T4H = FNMS(KP939062505, T4w, T4z);
					     T4Y = FNMS(KP772036680, T4l, T4e);
					     T4m = FMA(KP772036680, T4l, T4e);
					     T4Z = FNMS(KP734762448, T4A, T4t);
					     T4B = FMA(KP734762448, T4A, T4t);
					     T4C = FMA(KP994076283, T4B, T4m);
					     T4E = FNMS(KP994076283, T4B, T4m);
					     T4I = FMA(KP734762448, T4H, T4G);
					     T4T = FNMS(KP734762448, T4H, T4G);
					     T4S = FMA(KP772036680, T4K, T4J);
					     T4L = FNMS(KP772036680, T4K, T4J);
					}
					ro[WS(os, 3)] = FMA(KP998026728, T4C, T47);
					T4U = FMA(KP994076283, T4T, T4S);
					T4W = FNMS(KP994076283, T4T, T4S);
					T4M = FNMS(KP621716863, T4L, T4I);
					T4O = FMA(KP614372930, T4I, T4L);
					io[WS(os, 3)] = FNMS(KP998026728, T4U, T4R);
					T4D = FNMS(KP249506682, T4C, T47);
					T50 = FMA(KP614372930, T4Z, T4Y);
					T52 = FNMS(KP621716863, T4Y, T4Z);
					T4V = FMA(KP249506682, T4U, T4R);
					T4F = FNMS(KP557913902, T4E, T4D);
					T4N = FMA(KP557913902, T4E, T4D);
				   }
				   {
					E T3S, T3T, T3G, T41, T3K, T3N, T40, T51, T4X, T3Q, T3O, T3P;
					T51 = FMA(KP557913902, T4W, T4V);
					T4X = FNMS(KP557913902, T4W, T4V);
					ro[WS(os, 18)] = FNMS(KP949179823, T4O, T4N);
					ro[WS(os, 13)] = FMA(KP949179823, T4O, T4N);
					ro[WS(os, 8)] = FMA(KP943557151, T4M, T4F);
					ro[WS(os, 23)] = FNMS(KP943557151, T4M, T4F);
					io[WS(os, 8)] = FMA(KP943557151, T52, T51);
					io[WS(os, 23)] = FNMS(KP943557151, T52, T51);
					io[WS(os, 18)] = FNMS(KP949179823, T50, T4X);
					io[WS(os, 13)] = FMA(KP949179823, T50, T4X);
					{
					     E T3I, T3u, T3x, T3J, T3L, T3B, T3E, T3M, T3y, T3F;
					     T3I = FMA(KP126329378, T3s, T3t);
					     T3u = FNMS(KP126329378, T3t, T3s);
					     T3x = FNMS(KP470564281, T3w, T3v);
					     T3J = FMA(KP470564281, T3v, T3w);
					     T3L = FNMS(KP634619297, T3z, T3A);
					     T3B = FMA(KP634619297, T3A, T3z);
					     T3E = FNMS(KP827271945, T3D, T3C);
					     T3M = FMA(KP827271945, T3C, T3D);
					     T3S = FMA(KP912018591, T3x, T3u);
					     T3y = FNMS(KP912018591, T3x, T3u);
					     T3T = FMA(KP912575812, T3E, T3B);
					     T3F = FNMS(KP912575812, T3E, T3B);
					     T3G = FNMS(KP851038619, T3F, T3y);
					     T3Y = FMA(KP851038619, T3F, T3y);
					     T41 = FNMS(KP912018591, T3J, T3I);
					     T3K = FMA(KP912018591, T3J, T3I);
					     T3N = FMA(KP912575812, T3M, T3L);
					     T40 = FNMS(KP912575812, T3M, T3L);
					}
					ro[WS(os, 4)] = FNMS(KP992114701, T3G, T3r);
					T3Q = FNMS(KP851038619, T3N, T3K);
					T3O = FMA(KP851038619, T3N, T3K);
					T3U = FNMS(KP525970792, T3T, T3S);
					T3W = FMA(KP726211448, T3S, T3T);
					T42 = FNMS(KP726211448, T41, T40);
					T44 = FMA(KP525970792, T40, T41);
					T3P = FMA(KP248028675, T3O, T3H);
					io[WS(os, 4)] = FNMS(KP992114701, T3O, T3H);
					T3X = FMA(KP248028675, T3G, T3r);
					T3R = FNMS(KP554608978, T3Q, T3P);
					T3V = FMA(KP554608978, T3Q, T3P);
				   }
			      }
			 }
		    }
	       }
	       T3Z = FMA(KP554608978, T3Y, T3X);
	       T43 = FNMS(KP554608978, T3Y, T3X);
	       io[WS(os, 9)] = FNMS(KP803003575, T3W, T3V);
	       io[WS(os, 24)] = FMA(KP803003575, T3W, T3V);
	       io[WS(os, 19)] = FNMS(KP943557151, T3U, T3R);
	       io[WS(os, 14)] = FMA(KP943557151, T3U, T3R);
	       ro[WS(os, 14)] = FNMS(KP943557151, T44, T43);
	       ro[WS(os, 19)] = FMA(KP943557151, T44, T43);
	       ro[WS(os, 24)] = FMA(KP803003575, T42, T3Z);
	       ro[WS(os, 9)] = FNMS(KP803003575, T42, T3Z);
	  }
     }
}

#else				/* HAVE_FMA */

/* Generated by: ../../../genfft/gen_notw.native -compact -variables 4 -standalone -pipeline-latency 4 -n 25 -name n1_25 -include n.h */

/*
 * This function contains 352 FP additions, 184 FP multiplications,
 * (or, 260 additions, 92 multiplications, 92 fused multiply/add),
 * 101 stack variables, 20 constants, and 100 memory accesses
 */
#include "n.h"

void n1_25(const R *ri, const R *ii, R *ro, R *io, stride is, stride os, INT v, INT ivs, INT ovs)
{
     DK(KP425779291, +0.425779291565072648862502445744251703979973042);
     DK(KP904827052, +0.904827052466019527713668647932697593970413911);
     DK(KP637423989, +0.637423989748689710176712811676016195434917298);
     DK(KP770513242, +0.770513242775789230803009636396177847271667672);
     DK(KP998026728, +0.998026728428271561952336806863450553336905220);
     DK(KP062790519, +0.062790519529313376076178224565631133122484832);
     DK(KP992114701, +0.992114701314477831049793042785778521453036709);
     DK(KP125333233, +0.125333233564304245373118759816508793942918247);
     DK(KP684547105, +0.684547105928688673732283357621209269889519233);
     DK(KP728968627, +0.728968627421411523146730319055259111372571664);
     DK(KP481753674, +0.481753674101715274987191502872129653528542010);
     DK(KP876306680, +0.876306680043863587308115903922062583399064238);
     DK(KP844327925, +0.844327925502015078548558063966681505381659241);
     DK(KP535826794, +0.535826794978996618271308767867639978063575346);
     DK(KP248689887, +0.248689887164854788242283746006447968417567406);
     DK(KP968583161, +0.968583161128631119490168375464735813836012403);
     DK(KP250000000, +0.250000000000000000000000000000000000000000000);
     DK(KP559016994, +0.559016994374947424102293417182819058860154590);
     DK(KP587785252, +0.587785252292473129168705954639072768597652438);
     DK(KP951056516, +0.951056516295153572116439333379382143405698634);
     {
	  INT i;
	  for (i = v; i > 0; i = i - 1, ri = ri + ivs, ii = ii + ivs, ro = ro + ovs, io = io + ovs, MAKE_VOLATILE_STRIDE(100, is), MAKE_VOLATILE_STRIDE(100, os)) {
	       E T9, T4u, T2T, TP, T3H, TW, T5y, T3I, T2Q, T4v, Ti, Tr, Ts, T5m, T5n;
	       E T5v, T18, T4G, T34, T3M, T1G, T4J, T38, T3T, T1v, T4K, T37, T3W, T1j, T4H;
	       E T35, T3P, TB, TK, TL, T5p, T5q, T5w, T1T, T4N, T3c, T41, T2r, T4Q, T3e;
	       E T4b, T2g, T4R, T3f, T48, T24, T4O, T3b, T44;
	       {
		    E T1, T4, T7, T8, T2S, T2R, TN, TO;
		    T1 = ri[0];
		    {
			 E T2, T3, T5, T6;
			 T2 = ri[WS(is, 5)];
			 T3 = ri[WS(is, 20)];
			 T4 = T2 + T3;
			 T5 = ri[WS(is, 10)];
			 T6 = ri[WS(is, 15)];
			 T7 = T5 + T6;
			 T8 = T4 + T7;
			 T2S = T5 - T6;
			 T2R = T2 - T3;
		    }
		    T9 = T1 + T8;
		    T4u = FNMS(KP587785252, T2R, KP951056516 * T2S);
		    T2T = FMA(KP951056516, T2R, KP587785252 * T2S);
		    TN = KP559016994 * (T4 - T7);
		    TO = FNMS(KP250000000, T8, T1);
		    TP = TN + TO;
		    T3H = TO - TN;
	       }
	       {
		    E T2N, T2K, T2L, TS, T2O, TV, T2M, T2P;
		    T2N = ii[0];
		    {
			 E TQ, TR, TT, TU;
			 TQ = ii[WS(is, 5)];
			 TR = ii[WS(is, 20)];
			 T2K = TQ + TR;
			 TT = ii[WS(is, 10)];
			 TU = ii[WS(is, 15)];
			 T2L = TT + TU;
			 TS = TQ - TR;
			 T2O = T2K + T2L;
			 TV = TT - TU;
		    }
		    TW = FMA(KP951056516, TS, KP587785252 * TV);
		    T5y = T2N + T2O;
		    T3I = FNMS(KP587785252, TS, KP951056516 * TV);
		    T2M = KP559016994 * (T2K - T2L);
		    T2P = FNMS(KP250000000, T2O, T2N);
		    T2Q = T2M + T2P;
		    T4v = T2P - T2M;
	       }
	       {
		    E Ta, T1c, Tj, T1z, Th, T1h, TY, T1g, T13, T1d, T16, T1b, Tq, T1E, T1l;
		    E T1D, T1q, T1A, T1t, T1y;
		    Ta = ri[WS(is, 1)];
		    T1c = ii[WS(is, 1)];
		    Tj = ri[WS(is, 4)];
		    T1z = ii[WS(is, 4)];
		    {
			 E Tb, Tc, Td, Te, Tf, Tg;
			 Tb = ri[WS(is, 6)];
			 Tc = ri[WS(is, 21)];
			 Td = Tb + Tc;
			 Te = ri[WS(is, 11)];
			 Tf = ri[WS(is, 16)];
			 Tg = Te + Tf;
			 Th = Td + Tg;
			 T1h = Te - Tf;
			 TY = KP559016994 * (Td - Tg);
			 T1g = Tb - Tc;
		    }
		    {
			 E T11, T12, T19, T14, T15, T1a;
			 T11 = ii[WS(is, 6)];
			 T12 = ii[WS(is, 21)];
			 T19 = T11 + T12;
			 T14 = ii[WS(is, 11)];
			 T15 = ii[WS(is, 16)];
			 T1a = T14 + T15;
			 T13 = T11 - T12;
			 T1d = T19 + T1a;
			 T16 = T14 - T15;
			 T1b = KP559016994 * (T19 - T1a);
		    }
		    {
			 E Tk, Tl, Tm, Tn, To, Tp;
			 Tk = ri[WS(is, 9)];
			 Tl = ri[WS(is, 24)];
			 Tm = Tk + Tl;
			 Tn = ri[WS(is, 14)];
			 To = ri[WS(is, 19)];
			 Tp = Tn + To;
			 Tq = Tm + Tp;
			 T1E = Tn - To;
			 T1l = KP559016994 * (Tm - Tp);
			 T1D = Tk - Tl;
		    }
		    {
			 E T1o, T1p, T1w, T1r, T1s, T1x;
			 T1o = ii[WS(is, 9)];
			 T1p = ii[WS(is, 24)];
			 T1w = T1o + T1p;
			 T1r = ii[WS(is, 14)];
			 T1s = ii[WS(is, 19)];
			 T1x = T1r + T1s;
			 T1q = T1o - T1p;
			 T1A = T1w + T1x;
			 T1t = T1r - T1s;
			 T1y = KP559016994 * (T1w - T1x);
		    }
		    Ti = Ta + Th;
		    Tr = Tj + Tq;
		    Ts = Ti + Tr;
		    T5m = T1c + T1d;
		    T5n = T1z + T1A;
		    T5v = T5m + T5n;
		    {
			 E T17, T3L, T10, T3K, TZ;
			 T17 = FMA(KP951056516, T13, KP587785252 * T16);
			 T3L = FNMS(KP587785252, T13, KP951056516 * T16);
			 TZ = FNMS(KP250000000, Th, Ta);
			 T10 = TY + TZ;
			 T3K = TZ - TY;
			 T18 = T10 + T17;
			 T4G = T3K + T3L;
			 T34 = T10 - T17;
			 T3M = T3K - T3L;
		    }
		    {
			 E T1F, T3R, T1C, T3S, T1B;
			 T1F = FMA(KP951056516, T1D, KP587785252 * T1E);
			 T3R = FNMS(KP587785252, T1D, KP951056516 * T1E);
			 T1B = FNMS(KP250000000, T1A, T1z);
			 T1C = T1y + T1B;
			 T3S = T1B - T1y;
			 T1G = T1C - T1F;
			 T4J = T3S - T3R;
			 T38 = T1F + T1C;
			 T3T = T3R + T3S;
		    }
		    {
			 E T1u, T3V, T1n, T3U, T1m;
			 T1u = FMA(KP951056516, T1q, KP587785252 * T1t);
			 T3V = FNMS(KP587785252, T1q, KP951056516 * T1t);
			 T1m = FNMS(KP250000000, Tq, Tj);
			 T1n = T1l + T1m;
			 T3U = T1m - T1l;
			 T1v = T1n + T1u;
			 T4K = T3U + T3V;
			 T37 = T1n - T1u;
			 T3W = T3U - T3V;
		    }
		    {
			 E T1i, T3N, T1f, T3O, T1e;
			 T1i = FMA(KP951056516, T1g, KP587785252 * T1h);
			 T3N = FNMS(KP587785252, T1g, KP951056516 * T1h);
			 T1e = FNMS(KP250000000, T1d, T1c);
			 T1f = T1b + T1e;
			 T3O = T1e - T1b;
			 T1j = T1f - T1i;
			 T4H = T3O - T3N;
			 T35 = T1i + T1f;
			 T3P = T3N + T3O;
		    }
	       }
	       {
		    E Tt, T1X, TC, T2k, TA, T22, T1J, T21, T1O, T1Y, T1R, T1W, TJ, T2p, T26;
		    E T2o, T2b, T2l, T2e, T2j;
		    Tt = ri[WS(is, 2)];
		    T1X = ii[WS(is, 2)];
		    TC = ri[WS(is, 3)];
		    T2k = ii[WS(is, 3)];
		    {
			 E Tu, Tv, Tw, Tx, Ty, Tz;
			 Tu = ri[WS(is, 7)];
			 Tv = ri[WS(is, 22)];
			 Tw = Tu + Tv;
			 Tx = ri[WS(is, 12)];
			 Ty = ri[WS(is, 17)];
			 Tz = Tx + Ty;
			 TA = Tw + Tz;
			 T22 = Tx - Ty;
			 T1J = KP559016994 * (Tw - Tz);
			 T21 = Tu - Tv;
		    }
		    {
			 E T1M, T1N, T1U, T1P, T1Q, T1V;
			 T1M = ii[WS(is, 7)];
			 T1N = ii[WS(is, 22)];
			 T1U = T1M + T1N;
			 T1P = ii[WS(is, 12)];
			 T1Q = ii[WS(is, 17)];
			 T1V = T1P + T1Q;
			 T1O = T1M - T1N;
			 T1Y = T1U + T1V;
			 T1R = T1P - T1Q;
			 T1W = KP559016994 * (T1U - T1V);
		    }
		    {
			 E TD, TE, TF, TG, TH, TI;
			 TD = ri[WS(is, 8)];
			 TE = ri[WS(is, 23)];
			 TF = TD + TE;
			 TG = ri[WS(is, 13)];
			 TH = ri[WS(is, 18)];
			 TI = TG + TH;
			 TJ = TF + TI;
			 T2p = TG - TH;
			 T26 = KP559016994 * (TF - TI);
			 T2o = TD - TE;
		    }
		    {
			 E T29, T2a, T2h, T2c, T2d, T2i;
			 T29 = ii[WS(is, 8)];
			 T2a = ii[WS(is, 23)];
			 T2h = T29 + T2a;
			 T2c = ii[WS(is, 13)];
			 T2d = ii[WS(is, 18)];
			 T2i = T2c + T2d;
			 T2b = T29 - T2a;
			 T2l = T2h + T2i;
			 T2e = T2c - T2d;
			 T2j = KP559016994 * (T2h - T2i);
		    }
		    TB = Tt + TA;
		    TK = TC + TJ;
		    TL = TB + TK;
		    T5p = T1X + T1Y;
		    T5q = T2k + T2l;
		    T5w = T5p + T5q;
		    {
			 E T1S, T40, T1L, T3Z, T1K;
			 T1S = FMA(KP951056516, T1O, KP587785252 * T1R);
			 T40 = FNMS(KP587785252, T1O, KP951056516 * T1R);
			 T1K = FNMS(KP250000000, TA, Tt);
			 T1L = T1J + T1K;
			 T3Z = T1K - T1J;
			 T1T = T1L + T1S;
			 T4N = T3Z + T40;
			 T3c = T1L - T1S;
			 T41 = T3Z - T40;
		    }
		    {
			 E T2q, T49, T2n, T4a, T2m;
			 T2q = FMA(KP951056516, T2o, KP587785252 * T2p);
			 T49 = FNMS(KP587785252, T2o, KP951056516 * T2p);
			 T2m = FNMS(KP250000000, T2l, T2k);
			 T2n = T2j + T2m;
			 T4a = T2m - T2j;
			 T2r = T2n - T2q;
			 T4Q = T4a - T49;
			 T3e = T2q + T2n;
			 T4b = T49 + T4a;
		    }
		    {
			 E T2f, T47, T28, T46, T27;
			 T2f = FMA(KP951056516, T2b, KP587785252 * T2e);
			 T47 = FNMS(KP587785252, T2b, KP951056516 * T2e);
			 T27 = FNMS(KP250000000, TJ, TC);
			 T28 = T26 + T27;
			 T46 = T27 - T26;
			 T2g = T28 + T2f;
			 T4R = T46 + T47;
			 T3f = T28 - T2f;
			 T48 = T46 - T47;
		    }
		    {
			 E T23, T42, T20, T43, T1Z;
			 T23 = FMA(KP951056516, T21, KP587785252 * T22);
			 T42 = FNMS(KP587785252, T21, KP951056516 * T22);
			 T1Z = FNMS(KP250000000, T1Y, T1X);
			 T20 = T1W + T1Z;
			 T43 = T1Z - T1W;
			 T24 = T20 - T23;
			 T4O = T43 - T42;
			 T3b = T23 + T20;
			 T44 = T42 + T43;
		    }
	       }
	       {
		    E T5j, TM, T5k, T5s, T5u, T5o, T5r, T5t, T5l;
		    T5j = KP559016994 * (Ts - TL);
		    TM = Ts + TL;
		    T5k = FNMS(KP250000000, TM, T9);
		    T5o = T5m - T5n;
		    T5r = T5p - T5q;
		    T5s = FMA(KP951056516, T5o, KP587785252 * T5r);
		    T5u = FNMS(KP587785252, T5o, KP951056516 * T5r);
		    ro[0] = T9 + TM;
		    T5t = T5k - T5j;
		    ro[WS(os, 10)] = T5t - T5u;
		    ro[WS(os, 15)] = T5t + T5u;
		    T5l = T5j + T5k;
		    ro[WS(os, 20)] = T5l - T5s;
		    ro[WS(os, 5)] = T5l + T5s;
	       }
	       {
		    E T5x, T5z, T5A, T5E, T5F, T5C, T5D, T5G, T5B;
		    T5x = KP559016994 * (T5v - T5w);
		    T5z = T5v + T5w;
		    T5A = FNMS(KP250000000, T5z, T5y);
		    T5C = Ti - Tr;
		    T5D = TB - TK;
		    T5E = FMA(KP951056516, T5C, KP587785252 * T5D);
		    T5F = FNMS(KP587785252, T5C, KP951056516 * T5D);
		    io[0] = T5y + T5z;
		    T5G = T5A - T5x;
		    io[WS(os, 10)] = T5F + T5G;
		    io[WS(os, 15)] = T5G - T5F;
		    T5B = T5x + T5A;
		    io[WS(os, 5)] = T5B - T5E;
		    io[WS(os, 20)] = T5E + T5B;
	       }
	       {
		    E TX, T2U, T2u, T2Z, T2v, T2Y, T2A, T2V, T2D, T2J;
		    TX = TP + TW;
		    T2U = T2Q - T2T;
		    {
			 E T1k, T1H, T1I, T25, T2s, T2t;
			 T1k = FMA(KP968583161, T18, KP248689887 * T1j);
			 T1H = FMA(KP535826794, T1v, KP844327925 * T1G);
			 T1I = T1k + T1H;
			 T25 = FMA(KP876306680, T1T, KP481753674 * T24);
			 T2s = FMA(KP728968627, T2g, KP684547105 * T2r);
			 T2t = T25 + T2s;
			 T2u = T1I + T2t;
			 T2Z = T25 - T2s;
			 T2v = KP559016994 * (T1I - T2t);
			 T2Y = T1k - T1H;
		    }
		    {
			 E T2y, T2z, T2H, T2B, T2C, T2I;
			 T2y = FNMS(KP248689887, T18, KP968583161 * T1j);
			 T2z = FNMS(KP844327925, T1v, KP535826794 * T1G);
			 T2H = T2y + T2z;
			 T2B = FNMS(KP481753674, T1T, KP876306680 * T24);
			 T2C = FNMS(KP684547105, T2g, KP728968627 * T2r);
			 T2I = T2B + T2C;
			 T2A = T2y - T2z;
			 T2V = T2H + T2I;
			 T2D = T2B - T2C;
			 T2J = KP559016994 * (T2H - T2I);
		    }
		    ro[WS(os, 1)] = TX + T2u;
		    io[WS(os, 1)] = T2U + T2V;
		    {
			 E T2E, T2G, T2x, T2F, T2w;
			 T2E = FMA(KP951056516, T2A, KP587785252 * T2D);
			 T2G = FNMS(KP587785252, T2A, KP951056516 * T2D);
			 T2w = FNMS(KP250000000, T2u, TX);
			 T2x = T2v + T2w;
			 T2F = T2w - T2v;
			 ro[WS(os, 21)] = T2x - T2E;
			 ro[WS(os, 16)] = T2F + T2G;
			 ro[WS(os, 6)] = T2x + T2E;
			 ro[WS(os, 11)] = T2F - T2G;
		    }
		    {
			 E T30, T31, T2X, T32, T2W;
			 T30 = FMA(KP951056516, T2Y, KP587785252 * T2Z);
			 T31 = FNMS(KP587785252, T2Y, KP951056516 * T2Z);
			 T2W = FNMS(KP250000000, T2V, T2U);
			 T2X = T2J + T2W;
			 T32 = T2W - T2J;
			 io[WS(os, 6)] = T2X - T30;
			 io[WS(os, 16)] = T32 - T31;
			 io[WS(os, 21)] = T30 + T2X;
			 io[WS(os, 11)] = T31 + T32;
		    }
	       }
	       {
		    E T4F, T52, T4U, T5b, T56, T57, T51, T5f, T53, T5e;
		    T4F = T3H + T3I;
		    T52 = T4v - T4u;
		    {
			 E T4I, T4L, T4M, T4P, T4S, T4T;
			 T4I = FMA(KP728968627, T4G, KP684547105 * T4H);
			 T4L = FNMS(KP992114701, T4K, KP125333233 * T4J);
			 T4M = T4I + T4L;
			 T4P = FMA(KP062790519, T4N, KP998026728 * T4O);
			 T4S = FNMS(KP637423989, T4R, KP770513242 * T4Q);
			 T4T = T4P + T4S;
			 T4U = T4M + T4T;
			 T5b = KP559016994 * (T4M - T4T);
			 T56 = T4I - T4L;
			 T57 = T4P - T4S;
		    }
		    {
			 E T4V, T4W, T4X, T4Y, T4Z, T50;
			 T4V = FNMS(KP684547105, T4G, KP728968627 * T4H);
			 T4W = FMA(KP125333233, T4K, KP992114701 * T4J);
			 T4X = T4V - T4W;
			 T4Y = FNMS(KP998026728, T4N, KP062790519 * T4O);
			 T4Z = FMA(KP770513242, T4R, KP637423989 * T4Q);
			 T50 = T4Y - T4Z;
			 T51 = KP559016994 * (T4X - T50);
			 T5f = T4Y + T4Z;
			 T53 = T4X + T50;
			 T5e = T4V + T4W;
		    }
		    ro[WS(os, 3)] = T4F + T4U;
		    io[WS(os, 3)] = T52 + T53;
		    {
			 E T58, T59, T55, T5a, T54;
			 T58 = FMA(KP951056516, T56, KP587785252 * T57);
			 T59 = FNMS(KP587785252, T56, KP951056516 * T57);
			 T54 = FNMS(KP250000000, T53, T52);
			 T55 = T51 + T54;
			 T5a = T54 - T51;
			 io[WS(os, 8)] = T55 - T58;
			 io[WS(os, 18)] = T5a - T59;
			 io[WS(os, 23)] = T58 + T55;
			 io[WS(os, 13)] = T59 + T5a;
		    }
		    {
			 E T5g, T5i, T5d, T5h, T5c;
			 T5g = FMA(KP951056516, T5e, KP587785252 * T5f);
			 T5i = FNMS(KP587785252, T5e, KP951056516 * T5f);
			 T5c = FNMS(KP250000000, T4U, T4F);
			 T5d = T5b + T5c;
			 T5h = T5c - T5b;
			 ro[WS(os, 23)] = T5d - T5g;
			 ro[WS(os, 18)] = T5h + T5i;
			 ro[WS(os, 8)] = T5d + T5g;
			 ro[WS(os, 13)] = T5h - T5i;
		    }
	       }
	       {
		    E T3J, T4w, T4e, T4B, T4f, T4A, T4k, T4x, T4n, T4t;
		    T3J = T3H - T3I;
		    T4w = T4u + T4v;
		    {
			 E T3Q, T3X, T3Y, T45, T4c, T4d;
			 T3Q = FMA(KP876306680, T3M, KP481753674 * T3P);
			 T3X = FNMS(KP425779291, T3W, KP904827052 * T3T);
			 T3Y = T3Q + T3X;
			 T45 = FMA(KP535826794, T41, KP844327925 * T44);
			 T4c = FMA(KP062790519, T48, KP998026728 * T4b);
			 T4d = T45 + T4c;
			 T4e = T3Y + T4d;
			 T4B = T45 - T4c;
			 T4f = KP559016994 * (T3Y - T4d);
			 T4A = T3Q - T3X;
		    }
		    {
			 E T4i, T4j, T4r, T4l, T4m, T4s;
			 T4i = FNMS(KP481753674, T3M, KP876306680 * T3P);
			 T4j = FMA(KP904827052, T3W, KP425779291 * T3T);
			 T4r = T4i - T4j;
			 T4l = FNMS(KP844327925, T41, KP535826794 * T44);
			 T4m = FNMS(KP998026728, T48, KP062790519 * T4b);
			 T4s = T4l + T4m;
			 T4k = T4i + T4j;
			 T4x = T4r + T4s;
			 T4n = T4l - T4m;
			 T4t = KP559016994 * (T4r - T4s);
		    }
		    ro[WS(os, 2)] = T3J + T4e;
		    io[WS(os, 2)] = T4w + T4x;
		    {
			 E T4o, T4q, T4h, T4p, T4g;
			 T4o = FMA(KP951056516, T4k, KP587785252 * T4n);
			 T4q = FNMS(KP587785252, T4k, KP951056516 * T4n);
			 T4g = FNMS(KP250000000, T4e, T3J);
			 T4h = T4f + T4g;
			 T4p = T4g - T4f;
			 ro[WS(os, 22)] = T4h - T4o;
			 ro[WS(os, 17)] = T4p + T4q;
			 ro[WS(os, 7)] = T4h + T4o;
			 ro[WS(os, 12)] = T4p - T4q;
		    }
		    {
			 E T4C, T4D, T4z, T4E, T4y;
			 T4C = FMA(KP951056516, T4A, KP587785252 * T4B);
			 T4D = FNMS(KP587785252, T4A, KP951056516 * T4B);
			 T4y = FNMS(KP250000000, T4x, T4w);
			 T4z = T4t + T4y;
			 T4E = T4y - T4t;
			 io[WS(os, 7)] = T4z - T4C;
			 io[WS(os, 17)] = T4E - T4D;
			 io[WS(os, 22)] = T4C + T4z;
			 io[WS(os, 12)] = T4D + T4E;
		    }
	       }
	       {
		    E T33, T3j, T3i, T3z, T3r, T3s, T3q, T3D, T3v, T3C;
		    T33 = TP - TW;
		    T3j = T2T + T2Q;
		    {
			 E T36, T39, T3a, T3d, T3g, T3h;
			 T36 = FMA(KP535826794, T34, KP844327925 * T35);
			 T39 = FMA(KP637423989, T37, KP770513242 * T38);
			 T3a = T36 - T39;
			 T3d = FNMS(KP425779291, T3c, KP904827052 * T3b);
			 T3g = FNMS(KP992114701, T3f, KP125333233 * T3e);
			 T3h = T3d + T3g;
			 T3i = T3a + T3h;
			 T3z = KP559016994 * (T3a - T3h);
			 T3r = T3d - T3g;
			 T3s = T36 + T39;
		    }
		    {
			 E T3k, T3l, T3m, T3n, T3o, T3p;
			 T3k = FNMS(KP844327925, T34, KP535826794 * T35);
			 T3l = FNMS(KP637423989, T38, KP770513242 * T37);
			 T3m = T3k + T3l;
			 T3n = FMA(KP904827052, T3c, KP425779291 * T3b);
			 T3o = FMA(KP125333233, T3f, KP992114701 * T3e);
			 T3p = T3n + T3o;
			 T3q = T3m - T3p;
			 T3D = T3o - T3n;
			 T3v = KP559016994 * (T3m + T3p);
			 T3C = T3k - T3l;
		    }
		    ro[WS(os, 4)] = T33 + T3i;
		    io[WS(os, 4)] = T3j + T3q;
		    {
			 E T3t, T3y, T3w, T3x, T3u;
			 T3t = FNMS(KP587785252, T3s, KP951056516 * T3r);
			 T3y = FMA(KP951056516, T3s, KP587785252 * T3r);
			 T3u = FNMS(KP250000000, T3q, T3j);
			 T3w = T3u - T3v;
			 T3x = T3u + T3v;
			 io[WS(os, 14)] = T3t + T3w;
			 io[WS(os, 24)] = T3y + T3x;
			 io[WS(os, 19)] = T3w - T3t;
			 io[WS(os, 9)] = T3x - T3y;
		    }
		    {
			 E T3E, T3G, T3B, T3F, T3A;
			 T3E = FMA(KP951056516, T3C, KP587785252 * T3D);
			 T3G = FNMS(KP587785252, T3C, KP951056516 * T3D);
			 T3A = FNMS(KP250000000, T3i, T33);
			 T3B = T3z + T3A;
			 T3F = T3A - T3z;
			 ro[WS(os, 24)] = T3B - T3E;
			 ro[WS(os, 19)] = T3F + T3G;
			 ro[WS(os, 9)] = T3B + T3E;
			 ro[WS(os, 14)] = T3F - T3G;
		    }
	       }
	  }
     }
}

#endif				/* HAVE_FMA */
