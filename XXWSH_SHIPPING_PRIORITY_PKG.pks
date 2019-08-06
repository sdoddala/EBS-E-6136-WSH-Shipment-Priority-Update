create or replace PACKAGE XXWSH_SHIPPING_PRIORITY_PKG AUTHID CURRENT_USER
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
  Version   Date        Author           Remarks
  =======   =========== =============    ==============================
  1.0       24-JUL-2019 Srinivas Doddala     Initial draft version
  ===================================================================*/

   gc_module_name               CONSTANT VARCHAR2(30) := 'XXWSH_SHIPPING_PRIORITY_PKG';



------------------------------------------------------
-- public procedure to update shipping priority
---------------------------------------------------------
   PROCEDURE ship_priority_update (
      x_error_buf         OUT      VARCHAR2,
      x_retcode           OUT      NUMBER,
      p_organization      IN       VARCHAR2,
      p_Shipment_priority IN       VARCHAR2,
	  p_schedule_days     IN       NUMBER
   );

END XXWSH_SHIPPING_PRIORITY_PKG;
/