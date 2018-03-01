#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Astrali - astralhead@gmx.net

 Script Function: decode the bitpay.com URI containing Address and BTC amount to a format every wallet could use.

#ce ----------------------------------------------------------------------------



HttpSetUserAgent('Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)')


#include <String.au3>
#include <Array.au3>


Global $site = "https://bitpay.com/invoice-noscript?id="     ;Site used to decode the URI

;-------------------------------- Includes for GUI -------------------------------------------
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;---------------------------------------------------------------------------------------------
;--------------------------------------------- GUI -------------------------------------------
#Region ### START Koda GUI section ### Form=X:\DL\Dropbox\Dropbox\ALT-Coins\Autoit\bitpay\Bitpay.kxf
$Form1 = GUICreate("Bitpay-Decoder", 354, 111, 212, 145)
$BitpayID = GUICtrlCreateInput("Bitpay ID here!", 8, 8, 145, 21)
$BTCAddress = GUICtrlCreateInput("Send To", 8, 40, 243, 21)
$BTCAmount = GUICtrlCreateInput("0.00000000", 8, 72, 145, 21)
$Button1 = GUICtrlCreateButton("Decode", 168, 8, 75, 25)
$Button2 = GUICtrlCreateButton("Copy", 268, 40, 75, 25)
$Button3 = GUICtrlCreateButton("Copy", 268, 72, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;---------------------------------------------------------------------------------------------


;----------------------------------------Main Loop -------------------------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE	;The X - will close the Script
			Exit
		 Case $Button1			;The Decode Button will start the Decode Function
			Decodeit()
		 Case $Button2			;The Second Button (beside BTC address) will copy btc address to Clipboard
			   CopyBTCaddress()
		 Case $Button3			;The Third Button (beside BTC amount) will copy btc amount to Clipboard
			   CopyBTCamount()	   
	EndSwitch
WEnd
;---------------------------------------------------------------------------------------------



Func CopyBTCaddress()
   $BtcAddressRead = GuiCtrlRead($BTCAddress) ;Read from GUI
   Clipput($BtcAddressRead)					  ;Put address to Clipboard
   Msgbox(0,"Info","Copied the address : " & $BtcAddressRead & @CR &"                                     to Clipboard!",2) ; Output copied Address
EndFunc

Func CopyBTCamount()
   $BtcAmountRead = GuiCtrlRead($BTCAmount)  ;Read from GUI
   Clipput($BtcAmountRead)					 ;Put amount to Clipboard
   Msgbox(0,"Info","Copied the amount of: " & $BtcAmountRead & " to Clipboard!",2)	;Guess what a Msgbox will do! :)
EndFunc

Func Decodeit()
$ID = GuiCtrlRead($Bitpayid)				 ;Get Input from first Field (the URI or ID)
$Faulty = 0									 ;Set error check variable to 0 (no error)
if Stringleft($ID,10) = "bitcoin:?r" Then	 ;If $ID starts with bitcoin_?r it will be an URI and not an ID.
   $SplitID = Stringsplit($ID,"/i/",1)		 ;lets split the URI at the point our needed ID is starting at.

$ID = $SplitID[2]							 ;first row of array contains the unneccesary crap - row 2 contains the ID. Lets put this into a Variable $ID.

Elseif Stringlen($ID) <> 22 Then			 ;if the first field doesn't contain an URI and is not 22 didigts long (ID length) theres most probably something wrong!
$Faulty = 1									 ;set our error check to 1 (We got an error!)
EndIf

If $Faulty = 0 Then									;when there is no error
$content = Binarytostring(inetread($site & $ID))	;get the decoded info directly from bitpay!
$Splitcontent = Stringsplit($content,"<p>",1)		;lets split up the content we just stored.

$splitbtc = Stringsplit($Splitcontent[2],"Please send <em>exactly</em> <strong>",1)  ;split the info we already got more so we can extract the amount.
$splitbtc = Stringsplit($Splitbtc[2],"</strong> bitcoin to:",1)						 ;split up more.

$splitaddress = Stringsplit($Splitcontent[3],"</p><br><small>",1)					 ;split up the content that contains the address.

   Guictrlsetdata($BtcAddress,$Splitaddress[1])										 ;put the data we just got from splitting into the GUI
   Guictrlsetdata($BtcAmount,$Splitbtc[1])											 ;put the data we just got from splitting into the GUI
Else	;probably there was something faulty - so we wont split!
Msgbox(48,"ERROR","Please enter correct Bitpay URI or ID!")							 ;tell the user something went wrong.
EndIf
Endfunc

