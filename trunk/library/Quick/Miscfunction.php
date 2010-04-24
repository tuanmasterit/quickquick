<?php
/**
 *
 * @category    Quick
 * @package     Quick_Miscfunction
 * @author      trungpm
 */
class Quick_Miscfunction
{

	/**
	 * The length of Module name can be differrent. This make the problem of
	 */
	public static function spaceToMakeTheSameWidth($target, $expectedLength, $token){
		if($expectedLength <= mb_strlen($target,'UTF-8') + 1) // I don't insert space if the length difference is just one
		return '';

		$sb = $token; // Since the width of space seem to be reserved a smaller width than average characters, I put one more space
		$to = $expectedLength - mb_strlen($target,'UTF-8');
		$to = (int)($to - fmod($to,2))/2;
		for($i=0; $i<$to; $i++)
		$sb = $sb . $token;

		return $sb;

	} // spaceToMakeTheSameWidth

	public static function prnMsg($Msg,$Type='info', $Prefix=''){

		echo getMsg($Msg, $Type, $Prefix);

	}//prnMsg

	public static function getMsg($Msg,$Type='info',$Prefix=''){
		$Colour='';
		switch($Type){
			case 'error':
				$Class = 'error';
				$Prefix = $Prefix ? $Prefix : _('ERROR') . ' ' ._('Message Report');
				break;
			case 'warn':
				$Class = 'warn';
				$Prefix = $Prefix ? $Prefix : _('WARNING') . ' ' . _('Message Report');
				break;
			case 'success':
				$Class = 'success';
				$Prefix = $Prefix ? $Prefix : _('SUCCESS') . ' ' . _('Report');
				break;
			case 'info':
			default:
				$Prefix = $Prefix ? $Prefix : _('INFORMATION') . ' ' ._('Message');
				$Class = 'info';
		}
		return '<DIV class="'.$Class.'"><B>' . $Prefix . '</B> : ' .$Msg . '</DIV>';
	}//getMsg
}