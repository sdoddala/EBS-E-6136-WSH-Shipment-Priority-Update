CREATE OR REPLACE FORCE VIEW "APPS"."XXSC_PEGGING_SHIP_PRIORITY_V"
AS
   /*=====================================================================
   $Id: "APPS"."XXSC_PEGGING_SHIP_PRIORITY_V".sql $
   $Header: 
   =====================================================================
   Copyright (c) 2014 Select Comfort Corporation
   All rights reserved.
   =====================================================================
   File Name        :    "APPS"."XXSC_PEGGING_SHIP_PRIORITY_V".sql
   RICEW ID         :    
   Description      :    This view creating view all internal vcp relaesed orders 
   Usage            :    Used in the Cship priority change for the vcp relaesed internal order lines
   Parameters       :    NA
   Modification History:
   ====================
   Version   Date         Author              Remarks
   =======   ===========  =============       ==============================
   1.0       23-Jul-2019  Srinivas Doddala    Initial version
   ===================================================================*/
   SELECT DISTINCT
    mfp.pegging_id                  peg_id,
    mai.instance_code               instance_code,
    mpo.organization_code           org,
    md.order_number                 order_number,
    TO_CHAR(SUBSTR(md.order_number, 0, 11)) so,
    SUBSTR(md.Order_Number, INSTR(md.Order_Number,'(',1)+1,(INSTR(md.Order_Number,')',1)-2)-INSTR(md.Order_Number,'(',1)+1) line_num,
    msi1.item_name                  item,
    msi1.description                description,
    msi1.planner_code               planner,
    msi1.planning_time_fence_days   ptf,
    msi1.demand_time_fence_days     dtf,
    msi1.release_time_fence_days    rtf,
    mfp.demand_date                 demand_date,
    mfp.supply_date                 supply_date,
    mfp.demand_quantity             demand_quantity,
    mfp.supply_quantity             supply_qunatity,
   -- mfp.allocated_quantity          allocated_qunatity,
    SUBSTR(mp1.organization_code,INSTR(mp1.organization_code,':',1)+1 )         ship_from,
    TRUNC(ms.need_by_date)          need_by_date,
    TRUNC(ms.new_schedule_date) new_schedule_date,DECODE(ms.firm_planned_type,1, 'Yes', 2, 'No') firm_y_n,
    ms.order_number                 IR,
    ms.po_line_id                   source_document_line_id    
  FROM
    msc.msc_full_pegging         mfp
    JOIN msc.msc_plan_organizations   mpo ON mpo.organization_id = mfp.organization_id
                                             AND mfp.sr_instance_id = mpo.sr_instance_id
                                             AND mpo.organization_code NOT IN ('DV1:M02',  'DV1:M03'   ) 
    JOIN msc.msc_apps_instances       mai ON mai.instance_id = mfp.sr_instance_id
                                             AND mai.instance_code = 'DV1'
    JOIN msc.msc_system_items        msi1 ON msi1.inventory_item_id = mfp.inventory_item_id
                                             AND msi1.organization_id = mfp.organization_id
                                             AND msi1.plan_id = mfp.plan_id
                                             AND msi1.sr_instance_id = mfp.sr_instance_id
    JOIN msc.msc_demands              md ON md.plan_id = mfp.plan_id
                                             AND md.demand_id = mfp.demand_id                                                                                
                                             AND md.order_number IS NOT NULL
    JOIN msc.msc_supplies             ms ON ms.plan_id = mfp.plan_id
                                             AND ms.transaction_id = mfp.transaction_id                                             
                                             AND ms.order_number IS NOT NULL
                                            --  AND ms.order_number = '930631'
    JOIN msc.msc_plan_organizations   mp1 ON mp1.organization_id = ms.source_organization_id
                                            AND mp1.sr_instance_id = ms.source_sr_instance_id
                                            AND mp1.organization_code IN ('DV1:M02', 'DV1:M03'    )                                                 
 ORDER BY    mfp.demand_date DESC;

SHOW ERROR
EXIT;
/