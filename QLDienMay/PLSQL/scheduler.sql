---create sp
create or replace PROCEDURE Proc_Update_Phieu_Bao_Hanh AS
BEGIN
    SET TRANSACTION READ WRITE; 
        UPDATE PHIEUBAOHANH SET TRANGTHAI = 1 WHERE NGAYHETHAN < CURRENT_DATE;
        COMMIT;
END;

----create job
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'Update_PhieuBaoHanh',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'Proc_Update_Phieu_Bao_Hanh',
   start_date         =>  '28-APR-08 07.00.00 PM Australia/Sydney',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=2', /* every other day */
   end_date           =>  '20-NOV-23 07.00.00 PM Australia/Sydney',
   auto_drop          =>   FALSE,
   comments           =>  'Job cap nhat phieu bao hanh');
END;

----enable job
EXEC DBMS_SCHEDULER.ENABLE('Update_PhieuBaoHanh');