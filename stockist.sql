select
    `tabSales Invoice`.name as invoice,
    `tabSales Invoice`.posting_date as "Posting Date:Date/Posting date:100",
    `tabSales Invoice`.customer_name as "Customer Name:Data/Customer Name:100",
    `tabSales Invoice`.city as "City:Data/City:100",
    `tabSales Invoice`.state as "State:Data/State:100",
    sum(IF(`tabSales Invoice Item`.rate > 0,`tabSales Invoice Item`.qty,0)) AS INVQty,
    sum(IF(`tabSales Invoice Item`.rate = 0,`tabSales Invoice Item`.qty,0)) AS FreeQty,
    sum(IF(`tabSales Invoice Item`.rate = 0 and (`tabSales Invoice Item`.item_code like ('OBKIT%%') or `tabSales Invoice Item`.item_code like ('ORKIT%%')),`tabSales Invoice Item`.qty,0)) AS SuturingKit,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 2359" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QN2359,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 2180DA" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QN2180DA,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 2762F" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QN2762F,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 2763F" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QN2763F,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 3336AP6" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QL2215,
    sum(IF(`tabSales Invoice Item`.item_code = "QN 2826P6" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)) AS QL2615,
    sum((IF(`tabSales Invoice Item`.rate = 0,`tabSales Invoice Item`.qty,0)-(IF(`tabSales Invoice Item`.rate = 0 and (`tabSales Invoice Item`.item_code like ('OBKIT%%') or `tabSales Invoice Item`.item_code like ('ORKIT%%')),`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 2359" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 2180DA" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 2762F" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 2763F" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 3336AP6" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)+IF(`tabSales Invoice Item`.item_code = "QN 2826P6" and `tabSales Invoice Item`.rate = 0 ,`tabSales Invoice Item`.qty,0)))) AS Others,
    sum(IF(`tabSales Invoice Item`.item_code = "SS35W",`tabSales Invoice Item`.qty,0)) AS SS35W,
    sum((IF(`tabSales Invoice Item`.rate=0,`tabSales Invoice Item`.qty,0)) + (IF(`tabSales Invoice Item`.rate > 0,`tabSales Invoice Item`.qty,0))) AS TotQty,
    ROUND(`tabSales Invoice`.net_total,0) as InvAmt,
    ROUND(`tabSales Invoice`.grand_total,0) as InvAmtIncGst,
    `tabSales Invoice`.status as Status,
    SUBSTRING(`tabSales Invoice`.account_manager,1,length(`tabSales Invoice`.account_manager)-17) as ASM
from `tabSales Invoice Item`
left join `tabSales Invoice` on `tabSales Invoice`.`name` = `tabSales Invoice Item`.`parent`
where
    `tabSales Invoice`.docstatus=1
    and `tabSales Invoice`.`posting_date` BETWEEN %(from_date)s AND %(to_date)s
    group by `tabSales Invoice`.name