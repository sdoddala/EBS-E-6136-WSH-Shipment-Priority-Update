create or replace PACKAGE BODY XXWSH_SHIPPING_PRIORITY_PKG
AS
/*=====================================================================
  $Id: $
  $Header: $
  =====================================================================
             Copyright (c) 2016 Select Comfort Corporation
                         All rights reserved.
  =====================================================================
  File Name        : XXWSH_SHIPPING_PRIORITY_PKG
  RICEW ID         : 
  Description      : 


  Modification History:
  ====================
  Version   Date        Author                Remarks
  =======   =========== =============        =============================
  1.0       24-JUL-2019 Sriniavs Doddala     Initial draft version
  =========================================================================*/
------------------------------------------------------
-- public procedure to update shipping priority
---------------------------------------------------------
   PROCEDURE ship_priority_update (
      x_error_buf         OUT      VARCHAR2,
      x_retcode           OUT      NUMBER,
      p_organization      IN       VARCHAR2,
      p_Shipment_priority IN       VARCHAR2,
	  p_schedule_days     IN       NUMBER
   )
   IS
  lc_sub_process   CONSTANT VARCHAR2 (100) := 'SHIP_PRIORITY_UPDATE';
  l_header_rec OE_ORDER_PUB.Header_Rec_Type:= OE_ORDER_PUB.G_MISS_HEADER_REC;
  l_line_tbl OE_ORDER_PUB.Line_Tbl_Type;
  l_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type;
  l_header_adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type;
  l_line_adj_tbl OE_ORDER_PUB.line_adj_tbl_Type;
  l_header_scr_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type;
  l_line_scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type;
  l_request_rec OE_ORDER_PUB.Request_Rec_Type ;
  l_return_status      VARCHAR2(1000);
  l_msg_count          NUMBER;
  l_msg_data           VARCHAR2(1000);
  p_api_version_number NUMBER        := 1.0;
  p_init_msg_list      VARCHAR2(10) := FND_API.G_FALSE;
  p_return_values      VARCHAR2(10) := FND_API.G_FALSE;
  p_action_commit      VARCHAR2(10) := FND_API.G_FALSE;
  x_return_status      VARCHAR2(1);
  x_msg_count          NUMBER;
  x_msg_data           VARCHAR2(100);
  p_header_rec OE_ORDER_PUB.Header_Rec_Type                              := OE_ORDER_PUB.G_MISS_HEADER_REC;
  p_old_header_rec OE_ORDER_PUB.Header_Rec_Type                          := OE_ORDER_PUB.G_MISS_HEADER_REC;
  p_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type                     := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
  p_old_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type                 := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
  p_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type                     := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
  p_old_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type                 := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
  p_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type             := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
  p_old_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
  p_Header_price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type          := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
  p_old_Header_Price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type     := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
  p_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type              := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
  p_old_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
  p_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
  p_old_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type     := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
  p_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type             := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
  p_old_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type         := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
  p_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type     := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
  p_old_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
  p_line_tbl OE_ORDER_PUB.Line_Tbl_Type                                 := OE_ORDER_PUB.G_MISS_LINE_TBL;
  p_old_line_tbl OE_ORDER_PUB.Line_Tbl_Type                             := OE_ORDER_PUB.G_MISS_LINE_TBL;
  p_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type                         := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
  p_old_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type                     := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
  p_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type                         := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
  p_old_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type                     := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
  p_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type                 := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
  p_old_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type             := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
  p_Line_price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type             := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
  p_old_Line_Price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type         := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
  p_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type                 := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
  p_old_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type             := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
  p_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type             := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
  p_old_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type          := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
  p_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type                 := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
  p_old_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type             := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
  p_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type          := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
  p_old_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type     := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
  p_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type                      := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
  p_old_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type                  := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
  p_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type              := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
  p_old_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type         := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
  p_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type                     := OE_ORDER_PUB.G_MISS_REQUEST_TBL;
  x_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type;
  x_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type;
  x_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type;
  x_Header_price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type;
  x_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type;
  x_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type;
  x_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type;
  x_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type;
  x_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type;
  x_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type;
  x_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type;
  x_Line_price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type;
  x_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type;
  x_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type;
  x_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type;
  x_line_tbl OE_ORDER_PUB.Line_Tbl_Type ;
  x_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type;
  x_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type;
  x_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type;
  x_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type;
  X_DEBUG_FILE     VARCHAR2(100);
  l_line_tbl_index NUMBER;
  l_msg_index_out  NUMBER(10);
  l_debug_level    CONSTANT NUMBER       := oe_debug_pub.g_debug_level;
  
  CURSOR cur_iso IS 
SELECT
   ool.line_id ,ooh.order_number,ool.line_number,psp.item,psp.order_number sales_order
FROM
   xxsc_pegging_ship_priority_v@vcpdev1_as_apps.us.oracle.com psp,
   apps.oe_order_lines_all ool,
   apps.oe_order_headers_all ooh ,
   apps.wsh_delivery_details   wdd
WHERE
   1 = 1 
   AND psp.source_document_line_id = ool.source_document_line_id 
   AND ool.header_id = ooh.header_id 
   AND psp.line_num IS NOT NULL
   AND ool.SHIPMENT_PRIORITY_code <> p_Shipment_priority
   AND new_schedule_date <= (trunc(sysdate) + nvl(p_schedule_days,0))
   AND wdd.source_line_id = ool.line_id
   AND wdd.released_status in ('B','S','R')
   AND psp.ship_from = NVL(p_organization,psp.ship_from);
  -- AND ROWNUM < 10;

   BEGIN
   
     mo_global.init('ONT');
     -- Required for R12
     MO_GLOBAL.SET_POLICY_CONTEXT('S', 85);
    oe_msg_pub.initialize;
    oe_debug_pub.initialize;
	
	        -- xxsc_common_pkg.set_debug_on;
         xxsc_common_pkg.DEBUG ('Start SHIP_PRIORITY_UPDATE', lc_sub_process);
    -- **********************************************************
     xxsc_common_pkg.debug('ORG_ID ' || fnd_profile.value('ORG_ID'), lc_sub_process);
     xxsc_common_pkg.debug('Line ID ' || fnd_profile.value('LOGIN_ID'), lc_sub_process);
     xxsc_common_pkg.debug('Shipment Priority ' || fnd_profile.value('USER_ID'), lc_sub_process);
     -- *************************************************************
	 
	 fnd_file.put_line(fnd_file.log, 'Organization  :  '||p_organization);
	 fnd_file.put_line(fnd_file.log,  'Shipment priority   :'||p_Shipment_priority);
	 fnd_file.put_line(fnd_file.log, 'Schedule days : '||p_schedule_days);
	 
	
  for rec_iso in cur_iso loop
	l_line_tbl_index := 1; 

 
  -- Changed attributes
  l_line_tbl(l_line_tbl_index)                         := OE_ORDER_PUB.G_MISS_LINE_REC;
  l_line_tbl(l_line_tbl_index).line_id                 := rec_iso.line_id;
  l_line_tbl(l_line_tbl_index).change_reason          := 'Not provided';
  l_line_tbl(l_line_tbl_index).SHIPMENT_PRIORITY_CODE := p_Shipment_priority;
  l_line_tbl(l_line_tbl_index).operation               := OE_GLOBALS.G_OPR_UPDATE;
 
    
   -- CALL TO PROCESS ORDER
  OE_ORDER_PUB.process_order ( p_api_version_number => 1.0 ,
                              p_init_msg_list => fnd_api.g_false ,
                              p_return_values => fnd_api.g_false ,
                              p_action_commit => fnd_api.g_false ,
                              x_return_status => l_return_status ,
                              x_msg_count => l_msg_count ,
                              x_msg_data => l_msg_data ,
                              p_header_rec => l_header_rec ,
                              p_line_tbl => l_line_tbl ,
                              p_action_request_tbl => l_action_request_tbl,
                              x_header_rec => l_header_rec ,
                              x_header_val_rec => x_header_val_rec ,
                              x_Header_Adj_tbl => x_Header_Adj_tbl ,
                              x_Header_Adj_val_tbl => x_Header_Adj_val_tbl ,
                              x_Header_price_Att_tbl => x_Header_price_Att_tbl ,
                              x_Header_Adj_Att_tbl => x_Header_Adj_Att_tbl ,
                              x_Header_Adj_Assoc_tbl => x_Header_Adj_Assoc_tbl ,
                              x_Header_Scredit_tbl => x_Header_Scredit_tbl ,
                              x_Header_Scredit_val_tbl => x_Header_Scredit_val_tbl ,
                              x_line_tbl => x_line_tbl ,
                              x_line_val_tbl => x_line_val_tbl ,
                              x_Line_Adj_tbl => x_Line_Adj_tbl ,
                              x_Line_Adj_val_tbl => x_Line_Adj_val_tbl ,
                              x_Line_price_Att_tbl => x_Line_price_Att_tbl ,
                              x_Line_Adj_Att_tbl => x_Line_Adj_Att_tbl ,
                              x_Line_Adj_Assoc_tbl => x_Line_Adj_Assoc_tbl ,
                              x_Line_Scredit_tbl => x_Line_Scredit_tbl ,
                              x_Line_Scredit_val_tbl => x_Line_Scredit_val_tbl ,
                              x_Lot_Serial_tbl => x_Lot_Serial_tbl ,
                              x_Lot_Serial_val_tbl => x_Lot_Serial_val_tbl ,
                              x_action_request_tbl => l_action_request_tbl );

  -- Retrieve messages
  FOR i IN 1 .. l_msg_count
  LOOP
    Oe_Msg_Pub.get( p_msg_index => i , p_encoded => Fnd_Api.G_FALSE ,
                   p_data => l_msg_data ,
                   p_msg_index_out => l_msg_index_out);
    xxsc_common_pkg.debug('message is: ' || l_msg_data, lc_sub_process);
	fnd_file.put_line(fnd_file.log,'message is: ' || l_msg_data);
    xxsc_common_pkg.debug('message index is: ' || l_msg_index_out, lc_sub_process);
	fnd_file.put_line(fnd_file.log,'message index is: ' || l_msg_index_out);
	fnd_file.put_line(fnd_file.log,'Shipment priority change Failed for the order   :'||rec_iso.order_number||'  and line number : '||rec_iso.line_number);
  END LOOP;
  -- Check the return status
  IF l_return_status = FND_API.G_RET_STS_SUCCESS THEN
    xxsc_common_pkg.debug('Shipment priority change Successful    ' , lc_sub_process);
	fnd_file.put_line(fnd_file.log,'Shipment priority change Successful for order   :'||rec_iso.order_number||'  and line number : '||rec_iso.line_number||   '      Customer order :'||rec_iso.sales_order );
  END IF;  
				  
 end loop;
   COMMIT;
        xxsc_common_pkg.DEBUG ('End SHIP_PRIORITY_UPDATE', lc_sub_process);
   EXCEPTION
      WHEN OTHERS
      THEN
         xxsc_common_pkg.error
                            (   'Error While Submitting Concurrent Request '
                             || TO_CHAR (SQLCODE)
                             || '-'
                             || SQLERRM,
                             lc_sub_process,
                             'N'
                            );
         x_error_buf  := SQLERRM;
         x_retcode    := 2;
   END ship_priority_update;

END XXWSH_SHIPPING_PRIORITY_PKG;
/
SHOW err;
/