---------------------------------------------------------------------
-- [Revision #20200109T153423_515 changes on Thu Jan  9 15:34:23 2020 by Derek Zhan ]
-- safe script for: 'Deployment/ClientScripts/GenericScripts/ILX-20362_Upgrade_GenericScripts_OSHA_Merge_Template_Helper_Fields_20200109.sql'
---------------------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM net.DatabaseScriptsApplied WHERE CommitHash = '20200109T153423_515')
BEGIN
    BEGIN TRANSACTION T20200109T153423_515;
	   BEGIN TRY
	   
        
EXEC('
update net.cusEHSIncidentMang_OII
set OSHAONLYId = OSHARecordID
where OSHARecordable = 1

update osha
set 
osha.[Where] = CASE WHEN(LEN(inc.LocationDesc)>300) THEN substring(inc.LocationDesc,1,297) + ''...'' ELSE inc.LocationDesc END, 
osha.[Description] = CASE WHEN(LEN(es.Description)>500) THEN substring(es.Description,1,497) + ''...'' ELSE es.Description END
from net.cusEHSIncidentMang_OSHA osha 
inner join net.cusEHSIncidentMang_OII oii on osha.ID = oii.OSHARecordID
inner join net.cusEHSIncidentMang_Incident inc on oii.id = inc.ID
inner join net.cusEventFwk_EventScenario es on oii.id = es.id

update kpi
set kpi.LocShortName = CASE WHEN(LEN(loc.name)>30) THEN substring(loc.Name,1,27) + ''...'' ELSE loc.Name END
from net.cusEHSIncidentMang_OIIYearlyKPI kpi
inner join net.sysLocation loc on kpi.LocationID = loc.ID 
')
      
        INSERT INTO net.DatabaseScriptsApplied(CommitHash,DateApplied,ScriptName)
        VALUES('20200109T153423_515', GetUtcDate(), 'Deployment/ClientScripts/GenericScripts/ILX-19787_Upgrade_GenericScripts_OSHA_Merge_Template_Helper_Fields_20200109.sql')
        
        COMMIT TRANSACTION T20200109T153423_515
    END TRY
    BEGIN CATCH        
        DECLARE @ErrorMessage20200109T153423_515 NVARCHAR(4000);
        DECLARE @ErrorSeverity20200109T153423_515 INT;
        DECLARE @ErrorState20200109T153423_515 INT;
        SELECT @ErrorMessage20200109T153423_515 = 'T20200109T153423_515: ' + ERROR_MESSAGE(),
               @ErrorSeverity20200109T153423_515 = ERROR_SEVERITY(),
               @ErrorState20200109T153423_515 = ERROR_STATE()
        RAISERROR (@ErrorMessage20200109T153423_515, 18, @ErrorState20200109T153423_515);
		ROLLBACK TRANSACTION T20200109T153423_515
    END CATCH
END
---------------------------------------------------------------------
-- [End of revision 20200109T153423_515]
---------------------------------------------------------------------
