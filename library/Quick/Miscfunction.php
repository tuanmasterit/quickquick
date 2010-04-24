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
}