<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      trungpm
 */
class Quick_Accountant_Remoter_SaleBilling {

    const DEFAULT_TABLE_PRODUCT_TYPE = 3;
    const DEFAULT_TABLE_SERVICE_TYPE = 28;
    const DEFAULT_TABLE_UNIT_TYPE = 17;

    const DEFAULT_EXECUTION_SALES_INVOICE_TYPE = 14;

	const DEFAULT_VAT_EXPORT_TYPE = 3;
    const DEFAULT_VAT_EXCISE_TYPE = 2;
    const DEFAULT_VAT_TYPE = 1;

    public static function getArrayAccounting($type) {
        switch ($type) {
            case 'goods_not_export':
                return array(1=>array('typeId'=>45, 'colName'=>'amount', 'title'=>'Doanh thu bán hàng trong nước "'), 2=>array('typeId'=>50, 'colName'=>'vat_amount', 'title'=>'Thuế giá trị gia tăng "'), 3=>array('typeId'=>51, 'colName'=>'excise_amount', 'title'=>'Thuế tiêu thụ đặc biệt "'));
                break;
            case 'service_not_export':
                return array(1=>array('typeId'=>47, 'colName'=>'amount', 'title'=>'Doanh thu bán dịch vụ trong nước "'), 2=>array('typeId'=>50, 'colName'=>'vat_amount', 'title'=>'Thuế giá trị gia tăng "'), 3=>array('typeId'=>51, 'colName'=>'excise_amount', 'title'=>'Thuế tiêu thụ đặc biệt "'));
                break;
            case 'goods_export':
                return array(1=>array('typeId'=>46, 'colName'=>'amount', 'title'=>'Doanh thu xuất khẩu hàng "'), 2=>array('typeId'=>50, 'colName'=>'vat_amount', 'title'=>'Thuế giá trị gia tăng "'), 3=>array('typeId'=>49, 'colName'=>'export_amount', 'title'=>'Thuế xuất khẩu "'));
                break;
            case 'service_export':
                return array(1=>array('typeId'=>48, 'colName'=>'amount', 'title'=>'Doanh thu xuất khẩu dịch vụ "'), 2=>array('typeId'=>50, 'colName'=>'vat_amount', 'title'=>'Thuế giá trị gia tăng "'), 3=>array('typeId'=>49, 'colName'=>'export_amount', 'title'=>'Thuế xuất khẩu "'));
                break;
            default:
                return;
        }
    }

    /**
     * Retrieve customer list
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getListCustomer($limit, $start, $code = null, $name = null, &$total, $convertedCurrencyId) {
        return Quick::single('core/definition_subject')->cache()->getSupplierWithForexRateByArrayType(null, $limit, $start, $code, $name, &$total, array('is_customer'), $convertedCurrencyId);
    }

    /**
     * Retrieve list inventory voucher
     * lay nhung phieu xuat kho
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getListInventoryVoucherNotInheritance($limit, $start, $invoiceNumber, $fromDate, $toDate, $supplierId, &$total) {
        return Quick::single('accountant/inventory_voucher')->cache()->getInventoryVoucherOutputNotInheritance($limit, $start, $invoiceNumber, $fromDate, $toDate, $supplierId, &$total);
    }

    /**
     * Get batch note and entry type id with type vote
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getBatchNote($saleNumber, $saleDate, $cusName, $byExport, $forService) {
        list($date, $time) = explode(' ', $saleDate, 2);
        $convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $date);
        if ($byExport) {
            if ($forService) {
                $note = 'Hóa đơn xuất khẩu dịch vụ số "';
            } else {
                $note = 'Hóa đơn xuất khẩu hàng số "';
            }
        } else {
            if ($forService) {
                $note = 'Hóa đơn bán dịch vụ trong nước "';
            } else {
                $note = 'Hóa đơn bán hàng trong nước số "';
            }
        }
        return $note.$saleNumber.'", ngày "'.$convertedDate.'", "'.$cusName.'"';
    }

    /**
     * Insert each record of detail sale
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function insertRecordOfDetailSale($saleId, $byExport, $forService, $currencyId, $forexRate, 
	$newBatchId, $record, $debitAccountId, $creditAmountId, $creditVatId, $creditExportId, $creditExciseId) {
        

        $item = array();
        $item['sales_invoice_id'] = $saleId;
        $item['service_id'] = isset($record['service_id']) ? $record['service_id'] : 0;
        $item['product_id'] = isset($record['product_id']) ? $record['product_id'] : 0;
        $item['unit_id'] = isset($record['unit_id']) ? $record['unit_id'] : 0;
        $item['price'] = isset($record['price']) ? $record['price'] : 0;
        $item['quantity'] = isset($record['quantity']) ? $record['quantity'] : 0;
		$item['converted_quantity'] = isset($record['converted_quantity']) ? $record['converted_quantity'] : 0;
        $item['amount'] = $record['amount'];
        $item['converted_amount'] = $record['converted_amount'];
        $item['export_rate_id'] = $record['export_rate_id'];
        $item['export_rate'] = $record['export_rate'];
        $item['export_amount'] = $record['export_amount'];
        $item['excise_rate_id'] = $record['excise_rate_id'];
        $item['excise_rate'] = $record['excise_rate'];
        $item['excise_amount'] = $record['excise_amount'];
        $item['vat_rate_id'] = $record['vat_rate_id'];
        $item['vat_rate'] = $record['vat_rate'];
        $item['vat_amount'] = $record['vat_amount'];
        $item['total_amount'] = $record['total_amount'];
        $item['note'] = $record['note'];

        $item['debit_account_id'] = 0;
        $item['credit_account_id'] = 0;
		
        if ($forService) {
        	$tableId = self::DEFAULT_TABLE_SERVICE_TYPE;
            $detailId = $item['service_id'];
        } else {
        	$tableId = self::DEFAULT_TABLE_PRODUCT_TYPE;
            $detailId = $item['product_id'];
        }
		
		$entry = array('batch_id'=>$newBatchId, 'master_account_id'=>$debitAccountId, 'debit_credit'=>-1, 
		'original_amount'=>$record['total_amount']/$forexRate, 'currency_id'=>$currencyId, 
		'forex_rate'=>$forexRate, 'converted_amount'=>$record['total_amount'], 
		'obj_type_id_1'=>$tableId, 'obj_key_id_1'=>$detailId,
		'obj_type_id_2'=>self::DEFAULT_TABLE_UNIT_TYPE, 'obj_key_id_2'=>$item['unit_id']);
        $newEntryId = Quick::single('accountant/transaction_entry')->cache()->insertEntry($entry);
        
		$values = array();
		$values[] = "(".$newEntryId.",".$creditAmountId.",1".",".$item['amount'].",".$currencyId.",".$forexRate.",".$item['converted_amount'].
		",".$tableId.",".$detailId.",".self::DEFAULT_TABLE_UNIT_TYPE.",".$item['unit_id'].")";
		$values[] = "(".$newEntryId.",".$creditVatId.",1".",".$item['vat_amount']/$forexRate.",".$currencyId.",".$forexRate.",".$item['vat_amount'].
		",".$tableId.",".$detailId.",".self::DEFAULT_TABLE_UNIT_TYPE.",".$item['unit_id'].")";
		
		if($byExport){
			$values[] = "(".$newEntryId.",".$creditExportId.",1".",".$item['export_amount']/$forexRate.",".$currencyId.",".$forexRate.",".$item['export_amount'].
			",".$tableId.",".$detailId.",".self::DEFAULT_TABLE_UNIT_TYPE.",".$item['unit_id'].")";
		}else{
			$values[] = "(".$newEntryId.",".$creditExciseId.",1".",".$item['excise_amount']/$forexRate.",".$currencyId.",".$forexRate.",".$item['excise_amount'].
			",".$tableId.",".$detailId.",".self::DEFAULT_TABLE_UNIT_TYPE.",".$item['unit_id'].")";	
		}
		
		$query = "INSERT INTO `accountant_transaction_correspondence` (entry_id, detail_account_id, debit_credit, original_amount, currency_id, forex_rate, 
		converted_amount, obj_type_id_1, obj_key_id_1, obj_type_id_2, obj_key_id_2) "."VALUES ".implode(',', $values);
        $stmt = Quick::single('accountant/transaction_correspondence')->getAdapter()->prepare($query);
        $stmt->execute();
        $rowsAdded = $stmt->rowCount();
		
		$arrayCorres = array();
		

        return Quick::single('accountant/detail_sales')->cache()->insertProduct($item);
    }
	
    /**
     * Insert purchase invoice
     * @author	trungpm
     * @return array
     */
    public static function insertSaleInvoice($invoiceNumber, $invoiceDate, $seriNumber, $cusId, $cusName, $cusAddress,
	$cusTaxCode, $cusContact, $paymentType, $currencyId, $forexRate, $byExport, $forService, $description, 
	$debitAccountId, $creditAmountId, $creditVatId, $creditExportId, $creditExciseId, 
	$type, $inventoryInherId, $inventoryInherVoucherId, $detail, $currentPeriodId) {
        // insert voucher
        Quick::db()->beginTransaction();
        try {
            $newVoucherId = null;
            if ($type) {
                $newVoucherId = $inventoryInherVoucherId;
            } else {
                $voucher = array('execution_id'=>self::DEFAULT_EXECUTION_SALES_INVOICE_TYPE, 'period_id'=>$currentPeriodId, 'voucher_number'=>$invoiceNumber, 'voucher_date'=>$invoiceDate.' '.date('H:i:s'), 'from_transference'=>1, 'created_by_userid'=>Quick::session()->userId, 'date_entered'=>Quick_Date::now()->toSQLString(), 'last_modified_by_userid'=>Quick::session()->userId, 'date_last_modified'=>Quick_Date::now()->toSQLString());
                $newVoucherId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
            }

            if (isset($newVoucherId)) {
                // insert batch
                $tableId = self::DEFAULT_TABLE_PRODUCT_TYPE;
                $convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $invoiceDate);
                $newBatchId = null;
                $arrBatch = array();
                $note = $invoiceNumber.'", ngày "'.$convertedDate.'", "'.$cusName.'"';
                $batch = array('voucher_id'=>$newVoucherId, 'execution_id'=>self::DEFAULT_EXECUTION_SALES_INVOICE_TYPE, 'batch_note'=>'');
                if ($byExport) {
                    if ($forService) {
                        $batch['batch_note'] = 'Hóa đơn xuất khẩu dịch vụ số "'.$note;
                    } else {
                        $batch['batch_note'] = 'Hóa đơn xuất khẩu hàng số "'.$note;
                    }
                } else {
                    if ($forService) {
                        $batch['batch_note'] = 'Hóa đơn bán dịch vụ trong nước "'.$note;
                    } else {
                        $batch['batch_note'] = 'Hóa đơn bán hàng trong nước số "'.$note;
                    }
                }

                $newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
                if ($newBatchId) {
                    // get new invoice number
                    $setInvoiceDate = $invoiceDate.' '.date('H:i:s');
                    $sale = array('voucher_id'=>$newVoucherId, 'sales_serial_number'=>$seriNumber,
					'sales_invoice_number'=>$invoiceNumber, 'sales_invoice_date'=>$setInvoiceDate, 'customer_id'=>$cusId,
					'customer_name'=>$cusName, 'customer_address'=>$cusAddress, 'customer_tax_code'=>$cusTaxCode,
					'customer_contact'=>$cusContact, 'payment_type' => $paymentType, 
					'debit_account_id'=>$debitAccountId, 'credit_account_id_amount'=>$creditAmountId,
					'credit_account_id_vat'=>$creditVatId, 'crediit_account_id_export'=>$creditExportId,
					'credit_acount_id_excise'=>$creditExciseId,					
					
					'currency_id'=>$currencyId, 'forex_rate'=>$forexRate,
					'by_export'=>$byExport, 'for_service'=>$forService, 'description'=>$description,
					'created_by_userid'=>Quick::session()->userId, 'date_entered'=>Quick_Date::now()->toSQLString(), 'last_modified_by_userid'=>Quick::session()->userId, 'date_last_modified'=>Quick_Date::now()->toSQLString());
                    $newSaleId = Quick::single('accountant/sales_invoice')->cache()->insertSaleInvoice($sale);
                    if ($newSaleId) {
                        $total = 0.00;
						$totalVatAmount = 0.0;// su dung cho phan luu thong tin tang phai thu, tang phai tra
						$totalExportAmount = 0.0;// su dung cho phan luu thong tin tang phai tra
                        $totalExciseAmount = 0.0;// su dung cho phan luu thong tin tang phai tra
                        $sale['sales_invoice_id'] = $newSaleId;
                        $sale['sales_invoice_number'] = $invoiceNumber;
                        $sale['sales_invoice_date'] = Quick_Date::convertSQLDateToPHP('Y/m/d', $invoiceDate);
                        $sale['period_id'] = $currentPeriodId;
                        $sale['by_export'] = $byExport ? 1 : 0;
                        $sale['for_service'] = $forService ? 1 : 0;
                        foreach ($detail as $record) {

                            self::insertRecordOfDetailSale($newSaleId, $byExport, $forService, $sale['currency_id'], $sale['forex_rate'], 
							$newBatchId, $record, $debitAccountId, $creditAmountId, $creditVatId, $creditExportId, $creditExciseId);
                            $totalVatAmount += $record['vat_amount'];
                            $totalExportAmount += $record['export_amount'];
                            $totalExciseAmount += $record['excise_amount'];
                            $total += $record['total_amount'];
                        }

                        $sale['total_sale_amount'] = $total;
                        Quick::db()->commit();

                        Quick::db()->beginTransaction();
                        if ($type) {
                            $values = array();

                            Quick::single('accountant/inventory_voucher')->cache()->updateFieldOfInventoryVoucher($inventoryInherId, null, 'is_locked', 1, null);
                            $values[] = "(".$inventoryInherId.",".$newSaleId.",0,$newBatchId,
								".Quick::session()->userId.", '".Quick_Date::now()->toSQLString()."',
								".Quick::session()->userId.", '".Quick_Date::now()->toSQLString()."')";

                            if (! empty($values)) {
                                $query = "INSERT INTO `accountant_inventory_sales` (inventory_voucher_id, sales_invoice_id, " .
                                		"source_document, batch_id, "."created_by_userid, date_entered, last_modified_by_userid, " .
                                		"date_last_modified) "."VALUES ".implode(',', $values);
                                $stmt = Quick::single('accountant/inventory_sales')->getAdapter()->prepare($query);
                                $stmt->execute();
                                $rowsAdded = $stmt->rowCount();
                            }
                        }

						// them vao tu dong phan tang phai thu cua hoa don ban hang, luu tong tien hang
                        $basicInfo = array();
                        $basicInfo[] = "'$invoiceNumber'";
                        $basicInfo[] = "1"; // thuoc loai tang phai thu
                        $basicInfo[] = $sale['voucher_id'];
                        $basicInfo[] = "'$setInvoiceDate'";
                        $basicInfo[] = $sale['customer_id'];
                        $basicInfo[] = $sale['currency_id'];
                        $basicInfo[] = $sale['forex_rate'];
                        $basicInfo[] = "'".$sale['description']."'";

						self::autoInsertReceivableVoucher($basicInfo, 0, $total, $sale['forex_rate'], $newSaleId);
						//self::autoInsertPayableVoucher($basicInfo, 0, $total, $sale['forex_rate'], $newSaleId);
						
						/*
						self::autoInsertPayableVoucher($basicInfo, self::DEFAULT_VAT_TYPE, $totalVatAmount, $sale['forex_rate'], $newSaleId);

						if($sale['by_export']){
							self::autoInsertPayableVoucher($basicInfo, self::DEFAULT_VAT_EXPORT_TYPE, $totalExportAmount, $sale['forex_rate'], $newSaleId);
						}else{
							self::autoInsertPayableVoucher($basicInfo, self::DEFAULT_VAT_EXCISE_TYPE, $totalExciseAmount, $sale['forex_rate'], $newSaleId);
						}*/

                        Quick::db()->commit();
                        return $sale;
                    }
                    return null;
                } else
                    return null;
            } else
                return null;
        }
        catch(Exception $e) {
            Quick::db()->rollBack();
            throw $e;
        }
    }

	/**
     * auto insert receivable Voucher
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function autoInsertReceivableVoucher($receivableVoucher, $taxId, $amount, $forexRate, $salesId) {
        $receivableVoucher[] = $taxId; // truong hop
        $receivableVoucher[] = $amount;
        $receivableVoucher[] = $amount * $forexRate;
        $query = "INSERT INTO `accountant_receivable_voucher` (
								receivable_voucher_number,
								inc_dec,
								voucher_id,
								receivable_voucher_date,
								inc_subject_id,
								currency_id,
								forex_rate,
								description,
								tax_id,
								amount,
								converted_amount) "."VALUES (".implode(',', $receivableVoucher).")";
        $stmt = Quick::single('accountant/receivable_voucher')->getAdapter()->prepare($query);
        $stmt->execute();
        $newReceivableVoucherId = Quick::single('accountant/receivable_voucher')->getAdapter()->lastInsertId();
        if ($newReceivableVoucherId) {
            $salesReceivable = array(
			'receivable_voucher_id'=>$newReceivableVoucherId,
			'sales_invoice_id'=>$salesId,
			'created_by_userid'=>Quick::session()->userId,
			'date_entered'=>Quick_Date::now()->toSQLString(),
			'last_modified_by_userid'=>Quick::session()->userId,
			'date_last_modified'=>Quick_Date::now()->toSQLString());

            Quick::single('accountant/sales_receivable')->cache()->insertSalesReceivable($salesReceivable);
        }
    }

    /**
     * auto insert Payable Voucher
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function autoInsertPayableVoucher($payableVoucher, $taxId, $amount, $forexRate, $salesId) {
        $payableVoucher[] = $taxId; // truong hop
        $payableVoucher[] = $amount;
        $payableVoucher[] = $amount * $forexRate;
        $query = "INSERT INTO `accountant_payable_voucher` (
				payable_voucher_number,
				inc_dec,
				voucher_id,
				payable_voucher_date,
				inc_subject_id,
				currency_id,
				forex_rate,
				description,
				tax_id,
				amount,
				converted_amount) "."VALUES (".implode(',', $payableVoucher).")";
        $stmt = Quick::single('accountant/payable_voucher')->getAdapter()->prepare($query);
        $stmt->execute();
        $newPayableVoucherId = Quick::single('accountant/payable_voucher')->getAdapter()->lastInsertId();
        if ($newPayableVoucherId) {
            $salesPayable = array(
			'payable_voucher_id'=>$newPayableVoucherId,
			'sales_invoice_id'=>$salesId,
			'created_by_userid'=>Quick::session()->userId,
			'date_entered'=>Quick_Date::now()->toSQLString(),
			'last_modified_by_userid'=>Quick::session()->userId,
			'date_last_modified'=>Quick_Date::now()->toSQLString());

            Quick::single('accountant/sales_payable')->cache()->insertSalesPayable($salesPayable);
        }

    }

    /**
     * Retrieve list sales invoice
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getListSalesInvoice($limit, $start, $invoiceNumber, $fromDate, $toDate, $customer, &$total) {
        return Quick::single('accountant/sales_invoice')->cache()->getListSalesInvoice($limit, $start, $invoiceNumber, $fromDate, $toDate, $customer, &$total);
    }

    /**
     * Retrieve detail sales invoice by id
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getDetailSaleInvoiceById($salesInvoiceId) {
        return Quick::single('accountant/detail_sales')->cache()->getDetailSaleInvoiceById($salesInvoiceId);
    }

    /**
     * get list detail product of inventory voucher
     * lay chi tiet san pham cua phieu xuat kho chua ke thua tu hoa don,
     * nhung tong so luong con lai cua san pham trong phieu xuat kho chua ke thua
     * @author trungpm
     * @return array
     */
    public static function getDetailOfInventoryVoucherNotInheritance($inventoryId) {
        return Quick::single('accountant/inventory_voucher')->cache()->getDetailOfInventoryOutputNotInheritance($inventoryId);
    }

    /**
     * Update field of sale invoice
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function updateFieldOfSaleInvoice($salesInvoiceId, $batchId, $field, $value, $convertCurrency) {
        return Quick::single('accountant/sales_invoice')->cache()->updateFieldOfSaleInvoice($salesInvoiceId, $batchId, $field, $value, $convertCurrency);
    }

    /**
     * get array entry type of sale invoice
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getArrayEntryTypeOfSale($byExport, $forService) {
        if ($byExport) {
            if ($forService) {
                $result = self::getArrayAccounting('service_export');
            } else {
                $result = self::getArrayAccounting('goods_export');
            }
        } else {
            if ($forService) {
                $result = self::getArrayAccounting('service_not_export');
            } else {
                $result = self::getArrayAccounting('goods_not_export');
            }
        }
        return $result;
    }

    /**
     * get accouting of sale
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function getAccountingOfSale($batchId, $entryTypeId, $forService) {
        return Quick::single('accountant/sales_invoice')->cache()->getDetailAccountingByBatchId($batchId, $entryTypeId, $forService);
    }

	/**
     * Retrieve update field of detail sales invoice
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function updateFieldOfDetailSale($saleId, $batchId, $recordId, $field, $value, $coefficient) {
        return Quick::single('accountant/detail_sales')->cache()->updateFieldOfDetailSale($saleId, $batchId, $recordId, $field, $value, $coefficient);
    }

	/**
     * Delete list product of detail sale voucher
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function deleteDetail($saleId, $batchId, $records) {
        return Quick::single('accountant/detail_sales')->cache()->deleteListProduct($saleId, $batchId, $records);
    }

	/**
     * Delete sales voucher by Id
     * @author	trungpm
     * @return array Functions|mixed
     */
    public static function deleteSaleInvoice($arrRecord) {
        Quick::db()->beginTransaction();
        try {
            foreach ($arrRecord as $record) {
                Quick::single('accountant/sales_invoice')->cache()->deleteSaleInvoice($record['sales_invoice_id'], $record['batch_id'], $record['is_inheritanced']);
            }
            Quick::db()->commit();
            return true;
        }
        catch(Exception $e) {
            Quick::db()->rollBack();
            throw $e;
        }
    }
}
