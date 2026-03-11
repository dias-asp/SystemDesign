//////////////////////////////////////////////////////////////////////////
// REGION / AZ
//////////////////////////////////////////////////////////////////////////

CREATE (region:Region {name:"EU-Region"})

CREATE (az1:AZ {name:"AZ1"})
CREATE (az2:AZ {name:"AZ2"})

CREATE (az1)-[:LOCATED_IN]->(region)
CREATE (az2)-[:LOCATED_IN]->(region)

//////////////////////////////////////////////////////////////////////////
// SERVERS (PHYSICAL HARDWARE)
//////////////////////////////////////////////////////////////////////////

CREATE (srv_gateway1:Server {name:"gateway-server-1",cpu:16,ram:64})
CREATE (srv_gateway2:Server {name:"gateway-server-2",cpu:16,ram:64})

CREATE (srv_services1:Server {name:"services-server-1",cpu:32,ram:128})
CREATE (srv_services2:Server {name:"services-server-2",cpu:32,ram:128})

CREATE (srv_kafka1:Server {name:"kafka-server-1",cpu:16,ram:64})
CREATE (srv_kafka2:Server {name:"kafka-server-2",cpu:16,ram:64})

CREATE (srv_db1:Server {name:"db-server-1",cpu:32,ram:256})
CREATE (srv_db2:Server {name:"db-server-2",cpu:32,ram:256})

CREATE (srv_gateway1)-[:LOCATED_IN]->(az1)
CREATE (srv_gateway2)-[:LOCATED_IN]->(az2)

CREATE (srv_services1)-[:LOCATED_IN]->(az1)
CREATE (srv_services2)-[:LOCATED_IN]->(az2)

CREATE (srv_kafka1)-[:LOCATED_IN]->(az1)
CREATE (srv_kafka2)-[:LOCATED_IN]->(az2)

CREATE (srv_db1)-[:LOCATED_IN]->(az1)
CREATE (srv_db2)-[:LOCATED_IN]->(az2)

//////////////////////////////////////////////////////////////////////////
// EDGE LAYER
//////////////////////////////////////////////////////////////////////////

CREATE (ui:Service {name:"WSP_UI"})
CREATE (auth_ui:Service {name:"AUTH_UI"})

CREATE (firewall:Infrastructure {name:"Firewall"})
CREATE (rateLimiter:Infrastructure {name:"RateLimiter"})
CREATE (gateway:Service {name:"Gateway"})

CREATE (ui)-[:CONNECTS_TO]->(gateway)
CREATE (auth_ui)-[:CONNECTS_TO]->(gateway)

CREATE (gateway)-[:PROTECTED_BY]->(firewall)
CREATE (gateway)-[:LIMITED_BY]->(rateLimiter)

//////////////////////////////////////////////////////////////////////////
// CORE SERVICES
//////////////////////////////////////////////////////////////////////////

CREATE (auth:Service {name:"AuthService"})
CREATE (fileService:Service {name:"FileService"})
CREATE (profileService:Service {name:"ProfileService"})
CREATE (scheduleService:Service {name:"ScheduleService"})
CREATE (registrationService:Service {name:"RegistrationService"})
CREATE (journalService:Service {name:"JournalService"})

CREATE (gateway)-[:DEPENDS_ON]->(auth)
CREATE (gateway)-[:DEPENDS_ON]->(fileService)
CREATE (gateway)-[:DEPENDS_ON]->(profileService)
CREATE (gateway)-[:DEPENDS_ON]->(scheduleService)
CREATE (gateway)-[:DEPENDS_ON]->(registrationService)
CREATE (gateway)-[:DEPENDS_ON]->(journalService)

//////////////////////////////////////////////////////////////////////////
// DATA STORAGE
//////////////////////////////////////////////////////////////////////////

CREATE (authDB:Database {name:"AuthDB"})
CREATE (profileDB:Database {name:"ProfileDB"})
CREATE (scheduleDB:Database {name:"ScheduleDB"})
CREATE (registrationDB:Database {name:"RegistrationDB"})
CREATE (journalDB:Database {name:"JournalDB"})

CREATE (fileStorage:Storage {name:"FileStorage"})

CREATE (auth)-[:STORES_ON]->(authDB)
CREATE (profileService)-[:STORES_ON]->(profileDB)
CREATE (scheduleService)-[:STORES_ON]->(scheduleDB)
CREATE (registrationService)-[:STORES_ON]->(registrationDB)
CREATE (journalService)-[:STORES_ON]->(journalDB)
CREATE (fileService)-[:STORES_ON]->(fileStorage)

//////////////////////////////////////////////////////////////////////////
// REGISTRATION EVENT SYSTEM
//////////////////////////////////////////////////////////////////////////

CREATE (kafka:Infrastructure {name:"KafkaCluster"})
CREATE (worker:Service {name:"RegistrationWorker"})

CREATE (registrationService)-[:PUBLISHES_TO]->(kafka)
CREATE (worker)-[:CONSUMES_FROM]->(kafka)
CREATE (worker)-[:WRITES_TO]->(registrationDB)

//////////////////////////////////////////////////////////////////////////
// SERVICE DEPLOYMENT (RUNS_ON)
//////////////////////////////////////////////////////////////////////////

CREATE (gateway)-[:RUNS_ON]->(srv_gateway1)
CREATE (gateway)-[:RUNS_ON]->(srv_gateway2)

CREATE (auth)-[:RUNS_ON]->(srv_services1)
CREATE (fileService)-[:RUNS_ON]->(srv_services1)
CREATE (profileService)-[:RUNS_ON]->(srv_services1)

CREATE (scheduleService)-[:RUNS_ON]->(srv_services2)
CREATE (registrationService)-[:RUNS_ON]->(srv_services2)
CREATE (journalService)-[:RUNS_ON]->(srv_services2)

CREATE (worker)-[:RUNS_ON]->(srv_services1)

CREATE (kafka)-[:RUNS_ON]->(srv_kafka1)
CREATE (kafka)-[:RUNS_ON]->(srv_kafka2)

CREATE (authDB)-[:RUNS_ON]->(srv_db1)
CREATE (profileDB)-[:RUNS_ON]->(srv_db1)
CREATE (scheduleDB)-[:RUNS_ON]->(srv_db2)
CREATE (registrationDB)-[:RUNS_ON]->(srv_db2)
CREATE (journalDB)-[:RUNS_ON]->(srv_db2)

CREATE (fileStorage)-[:RUNS_ON]->(srv_db1);