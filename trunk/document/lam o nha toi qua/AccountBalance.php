<?php 
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Report Controller
 * @author      trungpm
 */
class Quick_Accountant_Remoter_AccountBalance {

    const DEFAULT_EXPORT_FILE_NAME = 'BangCanDoiTaiKhoan';
    const DEFAULT_DIR_UPLOAD = 'var/temp/export/';
    const DEFAULT_EXCEL_TYPE = 'Excel5'; // default Excel 2003 - Excel5,Excel2007
    
    /**
     * Export Account Balance Report
     * @author	trungpm
     * @return Excel File - Default Excel 2003(Excel5)
     */
    public static function executeExport() {
        set_time_limit(0);
        $staff = Quick::single('core/definition_staff')->cache()->getStaffById(Quick::session()->staffId);
        $creator = $staff['first_name'].' '.$staff['middle_name'].' '.$staff['last_name'];
        $objPHPExcel = new Quick_Excel(self::DEFAULT_EXPORT_FILE_NAME, self::DEFAULT_DIR_UPLOAD, self::DEFAULT_EXCEL_TYPE);
        $objPHPExcel->setActiveSheet(0);
        $objPHPExcel->setMetaData($creator, '', self::DEFAULT_EXPORT_FILE_NAME, Quick::config()->main->store->companyName);      
		$objPHPExcel->setPageSetup(80, PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4, PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
		$border_double = array (
			'style' => PHPExcel_Style_Border :: BORDER_DOUBLE			
		);
		
		$border_thin = array (
			'style' => PHPExcel_Style_Border :: BORDER_THIN			
		);
		
		$border_hair = array (
			'style' => PHPExcel_Style_Border :: BORDER_HAIR			
		);
		
		$border_medium = array (
			'style' => PHPExcel_Style_Border :: BORDER_MEDIUM			
		);
		
		$aligment_HorCent_VerCent = array (
			'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
		);
		
		$border_ALL_dot = array (
			'borders' => array (
				'left' => $border_hair,
				'top' => $border_hair,
				'right' => $border_hair,
				'bottom' => $border_hair
			)
		);
		
		$border_LTR_double = array (
			'borders' => array (
				'left' => $border_double,
				'top' => $border_double,
				'right' => $border_double
			)
		);
		
		$border_RT_medium = array (
			'borders' => array (
				'right' => $border_thin,
				'top' => $border_medium,
				'bottom' => $border_double
			)
		);
		
		$border_ALL_thin = array (
			'borders' => array (				
				'top' => $border_thin,
				'left' => $border_thin,
				'right' => $border_thin,
				'bottom' => $border_thin
			)
		);
		
		$border_BR_dot = array (
			'borders' => array (
				'right' => $border_thin,
				'bottom' => $border_hair
			),
			'alignment' => $aligment_HorCent_VerCent,
			'font' => array (
				'bold' => true
			)
		);
		
		$border_BR_dot2 = array (
			'borders' => array (
				'right' => $border_thin,
				'bottom' => $border_hair
			),
			'alignment' => $aligment_HorCent_VerCent,
			'font' => array (
				'italic' => true
			)
		);
		
		$border_BR_dot3 = array (
			'borders' => array (
				'right' => $border_thin,
				'bottom' => $border_hair
			)
		);
		
		$border_LTB_double = array (
			'borders' => array (
				'left' => $border_double,
				'right' => $border_double,
				'bottom' => $border_double
			)
		);
		
		$objPHPExcel->setDefaultStyle('Arial', 10);
		$objPHPExcel->setZoomScale(85);
		
		$objPHPExcel->setCellHorizontalAllignment("B7:J9", "center");
		$objPHPExcel->setCellVerticalAllignment("B7:J9", "center");
		
		$objPHPExcel->setColumnWidth("A", 1)
					->setColumnWidth("B", 11)
					->setColumnWidth("C", 1)
					->setColumnWidth("D", 43)
					->setColumnWidth("E", 18)
					->setColumnWidth("F", 18)
					->setColumnWidth("G", 18)
					->setColumnWidth("H", 18)
					->setColumnWidth("I", 18)
					->setColumnWidth("J", 18);
		$objPHPExcel->mergeCells("B2", "C2")
					->setText("B2","Tên DN:")
					->setText("B3","Địa chỉ:")
					->mergeCells("B3", "C3")
					->setText("B4","Mã Số Thuế:")
					->mergeCells("B4", "C4")
					->mergeCells("B5", "J5")
					
					->setText("B5","BẢNG CÂN ĐỐI TÀI KHOẢN", true, false, false, 16)
					->setCellHorizontalAllignment("B5", 'center')
					->mergeCells("I6", "J6")
					->setText("I6","Đơn vị tính: Đồng")
					->setCellHorizontalAllignment("I6", 'center')
					->setApplyFromArray("I6", array (						
						'alignment' => $aligment_HorCent_VerCent
					))
					->mergeCells("B7", "B8")
					->setWrapText("B7")
					->setRowHeight(5, 35)
					
					->setText("B7","SỐ HIỆU TK", true, false, false)
					->mergeCells("C7", "D8")
					->setDuplicateStyleArray($border_ALL_thin, "C7", "D8")
					->setText("C7","TÊN TÀI KHOẢN", true, false, false)
					
					->mergeCells("E7", "F7")					
					->setText("E7","SỐ DƯ ĐẦU KỲ", true, false, false)
					->setRowHeight(7, 21)
					->setDuplicateStyleArray($border_ALL_thin, "E7", "F7")
					->mergeCells("G7", "H7")
					->setText("G7","SỐ PHÁT SINH", true, false, false)
					->setDuplicateStyleArray($border_ALL_thin, "G7", "H7")
					
					->mergeCells("I7", "J7")					
					->setText("I7","SỐ DƯ CUỐI KỲ", true, false, false)
					->setDuplicateStyleArray($border_ALL_thin, "I7", "J7")
					->mergeCells("D2", "E2")
					->setDuplicateStyleArray($border_ALL_dot, "D2", "E2")
					
					->mergeCells("D3", "E3")
					->setDuplicateStyleArray($border_ALL_dot, "D3", "E3")
					->mergeCells("D4", "E4")
					->setDuplicateStyleArray($border_ALL_dot, "D4", "E4")
					
					->setText("E8","NỢ", true, false, false)
					->setApplyFromArray("E8", $border_ALL_thin)
					->setText("F8","CÓ", true, false, false)
					->setApplyFromArray("F8", $border_ALL_thin)
					->setText("G8","NỢ", true, false, false)
					->setApplyFromArray("G8", $border_ALL_thin)
					->setText("H8","CÓ", true, false, false)
					->setApplyFromArray("H8", $border_ALL_thin)
					->setText("I8","NỢ", true, false, false)
					->setApplyFromArray("I8", $border_ALL_thin)
					->setText("J8","CÓ", true, false, false)
					->setApplyFromArray("J8", $border_ALL_thin)
					->setRowHeight(8, 21)
					
					->mergeCells("C9", "D9")
					->setText("B9","1", true, false, false)
					->setApplyFromArray("B9", $border_RT_medium)
					->setText("C9","2", true, false, false)
					->setDuplicateStyleArray($border_RT_medium, "C9", "D9")
					->setText("E9","3", true, false, false)
					->setApplyFromArray("E9", $border_RT_medium)
					->setText("F9","4", true, false, false)
					->setApplyFromArray("F9", $border_RT_medium)
					->setText("G9","5", true, false, false)
					->setApplyFromArray("G9", $border_RT_medium)
					->setText("H9","6", true, false, false)
					->setApplyFromArray("H9", $border_RT_medium)
					->setText("I9","7", true, false, false)
					->setApplyFromArray("I9", $border_RT_medium)
					->setText("J9","8", true, false, false)					
					->setApplyFromArray("J9", $border_RT_medium)
					
					->mergeCells("B10", "J10")
					->setApplyFromArray("B10:J10", $border_ALL_thin)					
					
					->setRowHeight(6, 25)
					->setRowHeight(10, 4)
					->setDuplicateStyleArray($border_LTR_double, "B7", "J10");
				 
		$startRowIndex = $startRow = 11;
		$arrAccount = Quick::single('accountant/account_balance')->cache()->getAccountBalance();
		foreach($arrAccount as $account){
			$code = $account['account_code'];
			if(strlen($account['account_code']) == 3){
				$objPHPExcel->setValueExplicit("B$startRow", "$code", PHPExcel_Cell_DataType::TYPE_STRING)
							->setApplyFromArray("B$startRow", $border_BR_dot)
							->mergeCells("C$startRow", "D$startRow")
							->setText("C$startRow", $account['account_name'], true, false, false)
							->setApplyFromArray("C$startRow:D$startRow", $border_BR_dot3)
							->setApplyFromArray("E$startRow", $border_BR_dot)
							->setApplyFromArray("F$startRow", $border_BR_dot)
							->setApplyFromArray("G$startRow", $border_BR_dot)
							->setApplyFromArray("H$startRow", $border_BR_dot)
							->setApplyFromArray("I$startRow", $border_BR_dot)
							->setApplyFromArray("J$startRow", $border_BR_dot);
			}else{
				$objPHPExcel->setValueExplicit("B$startRow", "$code", PHPExcel_Cell_DataType::TYPE_STRING)
							->setApplyFromArray("B$startRow", $border_BR_dot2)
							->mergeCells("C$startRow", "D$startRow")
							->setText("C$startRow", $account['account_name'])
							->setApplyFromArray("C$startRow:D$startRow", $border_BR_dot3)
							->setApplyFromArray("E$startRow", $border_BR_dot2)
							->setApplyFromArray("F$startRow", $border_BR_dot2)
							->setApplyFromArray("G$startRow", $border_BR_dot2)
							->setApplyFromArray("H$startRow", $border_BR_dot2)
							->setApplyFromArray("I$startRow", $border_BR_dot2)
							->setApplyFromArray("J$startRow", $border_BR_dot2);
			}
			$objPHPExcel->setValueExplicit("G".$startRow, round($account['sum_phatsinh_no'], 2), PHPExcel_Cell_DataType::TYPE_NUMERIC)
						->setFormatCode("G".$startRow, '_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)')
						->setCellHorizontalAllignment("G".$startRow, "right")
						->setValueExplicit("H".$startRow, round($account['sum_phatsinh_co'], 2), PHPExcel_Cell_DataType::TYPE_NUMERIC)
						->setFormatCode("H".$startRow, '_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)')
						->setCellHorizontalAllignment("H".$startRow, "right");
			$startRow++;
		}
		$objPHPExcel->setDuplicateStyleArray($border_LTB_double, "B$startRowIndex", "J$startRow")
					->setText("B$startRow", "CỘNG:", true, true, false)					
					->mergeCells("B$startRow", "D$startRow")
					->setApplyFromArray("B$startRow:D$startRow", array (
						'borders' => array (
							'right' => $border_thin,
							'top' => $border_medium,
							'bottom' => $border_double
						),
						'alignment' => $aligment_HorCent_VerCent
					))
					->setText("E$startRow", "0", true)
					->setText("F$startRow", "0", true)
					->setText("G$startRow", "0", true)
					->setText("H$startRow", "0", true)
					->setText("I$startRow", "0", true)
					->setText("J$startRow", "0", true)
					->setApplyFromArray("E$startRow", $border_RT_medium)
					->setApplyFromArray("F$startRow", $border_RT_medium)
					->setApplyFromArray("G$startRow", $border_RT_medium)
					->setApplyFromArray("H$startRow", $border_RT_medium)
					->setApplyFromArray("I$startRow", $border_RT_medium)
					->setApplyFromArray("J$startRow", $border_RT_medium)
					->setRowHeight($startRow, 20);
		
		$objPHPExcel->setDuplicateStyleArray($border_LTB_double, "B$startRowIndex", "J$startRow");
		
		$startRow = $startRow+2;		
		$objPHPExcel->setText("B$startRow", "NGƯỜI LẬP", true)					
					->mergeCells("B$startRow", "D$startRow")					
					->mergeCells("H$startRow", "J$startRow")
					->setText("H$startRow", "GIÁM ĐỐC", true)
					->setApplyFromArray("B$startRow:J$startRow", array (						
						'alignment' => $aligment_HorCent_VerCent
					));
		$startRow = $startRow+1;			
		$objPHPExcel->setText("B$startRow", "(Ký, ghi rõ họ tên)", false, false, true)					
					->mergeCells("B$startRow", "D$startRow")					
					->mergeCells("H$startRow", "J$startRow")
					->setText("H$startRow", "(Ký, ghi rõ họ tên đóng dấu)", false, false, true)
					->setApplyFromArray("B$startRow:J$startRow", array (						
						'alignment' => $aligment_HorCent_VerCent
					));
		
		$startRow = $startRow+20;
		$objPHPExcel->setCellBackgroundColor("A1:P$startRow", PHPExcel_Style_Fill::FILL_SOLID, "FFFFFF")
					->setCellBackgroundColor("B10", PHPExcel_Style_Fill::FILL_SOLID, "C0C0C0");
				
        $objPHPExcel->outputToBrowser();
    }
}
