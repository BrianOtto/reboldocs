USAGE:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SORT&nbsp;series&nbsp;/case&nbsp;/skip&nbsp;size&nbsp;/compare&nbsp;comparator&nbsp;/part&nbsp;limit&nbsp;/all&nbsp;/reverse  
  
DESCRIPTION:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sorts&nbsp;a&nbsp;series;&nbsp;default&nbsp;sort&nbsp;order&nbsp;is&nbsp;ascending.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SORT&nbsp;is&nbsp;a&nbsp;function&nbsp;.  
  
RETURNS:  
&nbsp;&nbsp;&nbsp;&nbsp;(undocumented)  
  
ARGUMENTS:  
&nbsp;&nbsp;&nbsp;&nbsp;series&nbsp;[any-series!]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;At&nbsp;position&nbsp;(modified)  
  
REFINEMENTS:  
&nbsp;&nbsp;&nbsp;&nbsp;/case  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Case&nbsp;sensitive&nbsp;sort  
&nbsp;&nbsp;&nbsp;&nbsp;/skip  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Treat&nbsp;the&nbsp;series&nbsp;as&nbsp;records&nbsp;of&nbsp;fixed&nbsp;size  
&nbsp;&nbsp;&nbsp;&nbsp;size&nbsp;[integer!]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Size&nbsp;of&nbsp;each&nbsp;record  
&nbsp;&nbsp;&nbsp;&nbsp;/compare  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comparator&nbsp;offset,&nbsp;block&nbsp;or&nbsp;function  
&nbsp;&nbsp;&nbsp;&nbsp;comparator&nbsp;[integer!&nbsp;block!&nbsp;function!]  
&nbsp;&nbsp;&nbsp;&nbsp;/part  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sort&nbsp;only&nbsp;part&nbsp;of&nbsp;a&nbsp;series  
&nbsp;&nbsp;&nbsp;&nbsp;limit&nbsp;[any-number!&nbsp;any-series!]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Length&nbsp;of&nbsp;series&nbsp;to&nbsp;sort  
&nbsp;&nbsp;&nbsp;&nbsp;/all  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Compare&nbsp;all&nbsp;fields  
&nbsp;&nbsp;&nbsp;&nbsp;/reverse  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reverse&nbsp;sort&nbsp;order  

[Rebol.com docs](http://www.rebol.com/r3/docs/functions/sort.html)
___
Above this line is autogenerated. Place user comments below.