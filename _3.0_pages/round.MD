USAGE:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ROUND&nbsp;value&nbsp;/to&nbsp;scale&nbsp;/even&nbsp;/down&nbsp;/half-down&nbsp;/floor&nbsp;/ceiling&nbsp;/half-ceiling  
  
DESCRIPTION:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rounds&nbsp;a&nbsp;numeric&nbsp;value;&nbsp;halves&nbsp;round&nbsp;up&nbsp;(away&nbsp;from&nbsp;zero)&nbsp;by&nbsp;default.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ROUND&nbsp;is&nbsp;a&nbsp;function&nbsp;.  
  
RETURNS:  
&nbsp;&nbsp;&nbsp;&nbsp;(undocumented)  
  
ARGUMENTS:  
&nbsp;&nbsp;&nbsp;&nbsp;value&nbsp;[any-number!&nbsp;pair!&nbsp;money!&nbsp;time!]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The&nbsp;value&nbsp;to&nbsp;round  
  
REFINEMENTS:  
&nbsp;&nbsp;&nbsp;&nbsp;/to  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Return&nbsp;the&nbsp;nearest&nbsp;multiple&nbsp;of&nbsp;the&nbsp;scale&nbsp;parameter  
&nbsp;&nbsp;&nbsp;&nbsp;scale&nbsp;[any-number!&nbsp;money!&nbsp;time!]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Must&nbsp;be&nbsp;a&nbsp;non-zero&nbsp;value  
&nbsp;&nbsp;&nbsp;&nbsp;/even  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Halves&nbsp;round&nbsp;toward&nbsp;even&nbsp;results  
&nbsp;&nbsp;&nbsp;&nbsp;/down  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Round&nbsp;toward&nbsp;zero,&nbsp;ignoring&nbsp;discarded&nbsp;digits.&nbsp;(truncate)  
&nbsp;&nbsp;&nbsp;&nbsp;/half-down  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Halves&nbsp;round&nbsp;toward&nbsp;zero  
&nbsp;&nbsp;&nbsp;&nbsp;/floor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Round&nbsp;in&nbsp;negative&nbsp;direction  
&nbsp;&nbsp;&nbsp;&nbsp;/ceiling  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Round&nbsp;in&nbsp;positive&nbsp;direction  
&nbsp;&nbsp;&nbsp;&nbsp;/half-ceiling  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Halves&nbsp;round&nbsp;in&nbsp;positive&nbsp;direction  

[Rebol.com docs](http://www.rebol.com/r3/docs/functions/round.html)
___
Above this line is autogenerated. Place user comments below.