require 'sql_search'
if Rails.env == "development"
	 puts Person.count
	 Person.all.each do |d|
		d.destroy
	 end

	 puts PersonRecordStatus.count

	 PersonRecordStatus.all.each do |d|
		d.destroy
	 end

	 puts PersonIdentifier.count

	 PersonIdentifier.all.each do |d|
		d.destroy  
	 end

     SETTING = YAML.load_file("#{Rails.root}/config/elasticsearchsetting.yml")['elasticsearch']
     puts `curl -XDELETE #{SETTING['host']}:#{SETTING['port']}/#{SETTING['index']}`

     sql = "SET FOREIGN_KEY_CHECKS = 0;"
     SimpleSQL.query_exec(sql)

    	create_query = "DROP TABLE documents;
    					CREATE TABLE IF NOT EXISTS documents (
                        id int(11) NOT NULL AUTO_INCREMENT,
                        couchdb_id varchar(255) NOT NULL UNIQUE,
                        group_id varchar(255) DEFAULT NULL,
                        group_id2 varchar(255) DEFAULT NULL,
                        date_added datetime DEFAULT NULL,
                        title TEXT,
                        content TEXT,
                        created_at datetime NOT NULL,
                        updated_at datetime NOT NULL,
                        PRIMARY KEY (id),
                        FULLTEXT KEY content (content)
                      ) ENGINE=MyISAM DEFAULT CHARSET=utf8;"
        SimpleSQL.query_exec(create_query);

        puts "Drop documents"

        create_status_table = "DROP TABLE person_record_status ;
        					   CREATE TABLE IF NOT EXISTS person_record_status (
                                person_record_status_id varchar(225) NOT NULL,
                                person_record_id varchar(255) DEFAULT NULL,
                                status varchar(255) DEFAULT NULL,
                                prev_status varchar(255) DEFAULT NULL,
                                district_code varchar(255) DEFAULT NULL,
                                facility_code varchar(255) DEFAULT NULL,
                                voided tinyint(1) NOT NULL DEFAULT '0',
                                reprint tinyint(1) NOT NULL DEFAULT '0',
                                registration_type  varchar(255) DEFAULT NULL,
                                creator varchar(255) DEFAULT NULL,
                                updated_at datetime DEFAULT NULL,
                                created_at datetime DEFAULT NULL,
                              PRIMARY KEY (person_record_status_id)
                            ) ENGINE=InnoDB DEFAULT CHARSET=latin1;"
        SimpleSQL.query_exec(create_status_table); 

         puts "Drop person_record_status"  

        create_identifier_table = "DROP TABLE person_identifier;
        						   CREATE TABLE person_identifier (
                                    person_identifier_id varchar(225) NOT NULL,
                                    person_record_id varchar(255) DEFAULT NULL,
                                    identifier_type varchar(255) DEFAULT NULL,
                                    identifier varchar(255) DEFAULT NULL,
                                    check_digit text,
                                    site_code varchar(255) DEFAULT NULL,
                                    den_sort_value varchar(255) DEFAULT NULL,
                                    drn_sort_value varchar(255) DEFAULT NULL,
                                    district_code varchar(255) DEFAULT NULL,
                                    creator varchar(255) DEFAULT NULL,
                                    _rev varchar(255) DEFAULT NULL,
                                    updated_at datetime DEFAULT NULL,
                                    created_at datetime DEFAULT NULL,
                                  PRIMARY KEY (person_identifier_id)
                                ) ENGINE=InnoDB DEFAULT CHARSET=latin1;"  
                                
        SimpleSQL.query_exec(create_identifier_table);

        puts "Drop person_record_status"   

        if CONFIG['site_type'] != "facility"
            create_query_den_table = "DROP TABLE  IF EXISTS dens ;
            						  CREATE TABLE IF NOT EXISTS dens (
                                          den_id int(11) NOT NULL AUTO_INCREMENT,
                                          person_id varchar(225) NOT NULL,
                                          den varchar(15) NOT NULL,
                                          den_sort_value varchar(15) NOT NULL,
                                          created_at datetime NOT NULL,
                                          updated_at datetime NOT NULL,
                                          PRIMARY KEY (den_id),
                                          UNIQUE KEY den (den),
                                          KEY person_id (person_id),
                                          CONSTRAINT dens_ibfk_1 FOREIGN KEY (person_id) REFERENCES people (person_id)
                                      ) ENGINE=InnoDB DEFAULT CHARSET=latin1;"
              SimpleSQL.query_exec(create_query_den_table)

              puts "Drop dens"   
        end

        create_people_table = "SET FOREIGN_KEY_CHECKS = 0;
                              DROP TABLE IF EXISTS people;
                              CREATE TABLE people (
                                person_id varchar(225) NOT NULL,
                                first_name varchar(255) DEFAULT NULL,
                                middle_name varchar(255) DEFAULT NULL,
                                last_name varchar(255) DEFAULT NULL,
                                first_name_code varchar(255) DEFAULT NULL,
                                last_name_code varchar(255) DEFAULT NULL,
                                middle_name_code varchar(255) DEFAULT NULL,
                                gender varchar(255) DEFAULT NULL,
                                birthdate date DEFAULT NULL,
                                birthdate_estimated int(11) DEFAULT NULL,
                                date_of_death date DEFAULT NULL,
                                birth_certificate_number varchar(255) DEFAULT NULL,
                                nationality_id varchar(255) DEFAULT NULL,
                                nationality varchar(255) DEFAULT NULL,
                                place_of_death varchar(255) DEFAULT NULL,
                                hospital_of_death_id varchar(255) DEFAULT NULL,
                                hospital_of_death varchar(255) DEFAULT NULL,
                                other_place_of_death varchar(255) DEFAULT NULL,
                                other_place_of_death_village varchar(255) DEFAULT NULL,
                                place_of_death_village varchar(255) DEFAULT NULL,
                                place_of_death_village_id varchar(255) DEFAULT NULL,
                                other_place_of_death_ta varchar(255) DEFAULT NULL,
                                place_of_death_ta_id varchar(255) DEFAULT NULL,
                                place_of_death_ta varchar(255) DEFAULT NULL,
                                place_of_death_district_id varchar(255) DEFAULT NULL,
                                place_of_death_district varchar(255) DEFAULT NULL,
                                place_of_death_country varchar(255) DEFAULT NULL,
                                place_of_death_foreign varchar(255) DEFAULT NULL,
                                place_of_death_foreign_state varchar(255) DEFAULT NULL,
                                place_of_death_foreign_district varchar(255) DEFAULT NULL,
                                place_of_death_foreign_village varchar(255) DEFAULT NULL,
                                place_of_death_foreign_hospital varchar(255) DEFAULT NULL,
                                cause_of_death_available varchar(255) DEFAULT NULL,
                                cause_of_death1 varchar(255) DEFAULT NULL,
                                icd_10_1 varchar(255) DEFAULT NULL,
                                other_cause_of_death1 varchar(255) DEFAULT NULL,
                                onset_death_interval1 varchar(255) DEFAULT NULL,
                                cause_of_death2 varchar(255) DEFAULT NULL,
                                icd_10_2 varchar(255) DEFAULT NULL,
                                other_cause_of_death2 varchar(255) DEFAULT NULL,
                                onset_death_interval2 varchar(255) DEFAULT NULL,
                                cause_of_death3 varchar(255) DEFAULT NULL,
                                icd_10_3 varchar(255) DEFAULT NULL,
                                other_cause_of_death3 varchar(255) DEFAULT NULL,
                                onset_death_interval3 varchar(255) DEFAULT NULL,
                                cause_of_death4 varchar(255) DEFAULT NULL,
                                icd_10_4 varchar(255) DEFAULT NULL,
                                other_cause_of_death4 varchar(255) DEFAULT NULL,
                                onset_death_interval4 varchar(255) DEFAULT NULL,
                                cause_of_death_conditions varchar(255) DEFAULT NULL,
                                icd_10_code varchar(255) DEFAULT NULL,
                                manner_of_death varchar(255) DEFAULT NULL,
                                other_manner_of_death varchar(255) DEFAULT NULL,
                                death_by_accident varchar(255) DEFAULT NULL,
                                other_death_by_accident varchar(255) DEFAULT NULL,
                                other_home_village varchar(255) DEFAULT NULL,
                                home_village_id varchar(255) DEFAULT NULL,
                                home_village varchar(255) DEFAULT NULL,
                                other_home_ta varchar(255) DEFAULT NULL,
                                home_ta_id varchar(255) DEFAULT NULL,
                                home_ta varchar(255) DEFAULT NULL,
                                home_district_id varchar(255) DEFAULT NULL,
                                home_district varchar(255) DEFAULT NULL,
                                home_country_id varchar(255) DEFAULT NULL,
                                home_country varchar(255) DEFAULT NULL,
                                home_foreign_state varchar(255) DEFAULT NULL,
                                home_foreign_district varchar(255) DEFAULT NULL,
                                home_foreign_village varchar(255) DEFAULT NULL,
                                home_foreign_address varchar(255) DEFAULT NULL,
                                other_current_village varchar(255) DEFAULT NULL,
                                current_village_id varchar(255) DEFAULT NULL,
                                current_village varchar(255) DEFAULT NULL,
                                other_current_ta varchar(255) DEFAULT NULL,
                                current_ta_id varchar(255) DEFAULT NULL,
                                current_ta varchar(255) DEFAULT NULL,
                                current_district_id varchar(255) DEFAULT NULL,
                                current_district varchar(255) DEFAULT NULL,
                                current_country_id varchar(255) DEFAULT NULL,
                                current_country varchar(255) DEFAULT NULL,
                                current_foreign_state varchar(255) DEFAULT NULL,
                                current_foreign_district varchar(255) DEFAULT NULL,
                                current_foreign_village varchar(255) DEFAULT NULL,
                                current_foreign_address varchar(255) DEFAULT NULL,
                                died_while_pregnant varchar(255) DEFAULT NULL,
                                updated_by varchar(255) DEFAULT NULL,
                                voided_by varchar(255) DEFAULT NULL,
                                voided_date datetime DEFAULT NULL,
                                voided tinyint(1) NOT NULL DEFAULT '0',
                                form_signed varchar(255) DEFAULT NULL,
                                approved varchar(255) DEFAULT NULL,
                                status_changed_by varchar(255) DEFAULT NULL,
                                npid varchar(255) DEFAULT NULL,
                                approved_by varchar(255) DEFAULT NULL,
                                approved_at datetime DEFAULT NULL,
                                delayed_registration varchar(255) DEFAULT NULL,
                                registration_type varchar(255) DEFAULT NULL,
                                court_order varchar(255) DEFAULT NULL,
                                court_order_number varchar(255) DEFAULT NULL,
                                police_report varchar(255) DEFAULT NULL,
                                police_report_number varchar(255) DEFAULT NULL,
                                commissioner_documents varchar(255) DEFAULT NULL,
                                mother_id_number varchar(255) DEFAULT NULL,
                                mother_first_name varchar(255) DEFAULT NULL,
                                mother_middle_name varchar(255) DEFAULT NULL,
                                mother_last_name varchar(255) DEFAULT NULL,
                                mother_first_name_code varchar(255) DEFAULT NULL,
                                mother_last_name_code varchar(255) DEFAULT NULL,
                                mother_middle_name_code varchar(255) DEFAULT NULL,
                                mother_gender varchar(255) DEFAULT NULL,
                                mother_birthdate date DEFAULT NULL,
                                mother_birthdate_estimated varchar(255) DEFAULT NULL,
                                mother_current_village_id varchar(255) DEFAULT NULL,
                                mother_current_ta_id varchar(255) DEFAULT NULL,
                                mother_current_district_id varchar(255) DEFAULT NULL,
                                mother_current_village varchar(255) DEFAULT NULL,
                                mother_current_ta varchar(255) DEFAULT NULL,
                                mother_current_district varchar(255) DEFAULT NULL,
                                mother_home_village varchar(255) DEFAULT NULL,
                                mother_home_ta_id varchar(255) DEFAULT NULL,
                                mother_home_district_id varchar(255) DEFAULT NULL,
                                mother_home_country_id varchar(255) DEFAULT NULL,
                                mother_nationality_id varchar(255) DEFAULT NULL,
                                mother_home_village_id varchar(255) DEFAULT NULL,
                                mother_home_ta varchar(255) DEFAULT NULL,
                                mother_home_district varchar(255) DEFAULT NULL,
                                mother_home_country varchar(255) DEFAULT NULL,
                                mother_nationality varchar(255) DEFAULT NULL,
                                mother_occupation varchar(255) DEFAULT NULL,
                                mother_residential_country_id varchar(255) DEFAULT NULL,
                                mother_residential_country varchar(255) DEFAULT NULL,
                                mother_foreigner_current_district_id varchar(255) DEFAULT NULL,
                                mother_foreigner_current_village_id varchar(255) DEFAULT NULL,
                                mother_foreigner_current_ta_id varchar(255) DEFAULT NULL,
                                mother_foreigner_current_district varchar(255) DEFAULT NULL,
                                mother_foreigner_current_village varchar(255) DEFAULT NULL,
                                mother_foreigner_current_ta varchar(255) DEFAULT NULL,
                                mother_foreigner_home_district_id varchar(255) DEFAULT NULL,
                                mother_foreigner_home_village_id varchar(255) DEFAULT NULL,
                                mother_foreigner_home_ta_id varchar(255) DEFAULT NULL,
                                mother_foreigner_home_district varchar(255) DEFAULT NULL,
                                mother_foreigner_home_village varchar(255) DEFAULT NULL,
                                mother_foreigner_home_ta varchar(255) DEFAULT NULL,
                                father_id_number varchar(255) DEFAULT NULL,
                                father_first_name varchar(255) DEFAULT NULL,
                                father_middle_name varchar(255) DEFAULT NULL,
                                father_last_name varchar(255) DEFAULT NULL,
                                father_first_name_code varchar(255) DEFAULT NULL,
                                father_last_name_code varchar(255) DEFAULT NULL,
                                father_middle_name_code varchar(255) DEFAULT NULL,
                                father_gender varchar(255) DEFAULT NULL,
                                father_birthdate date DEFAULT NULL,
                                father_birthdate_estimated varchar(255) DEFAULT NULL,
                                father_current_village_id varchar(255) DEFAULT NULL,
                                father_current_ta_id varchar(255) DEFAULT NULL,
                                father_current_district_id varchar(255) DEFAULT NULL,
                                father_current_village varchar(255) DEFAULT NULL,
                                father_current_ta varchar(255) DEFAULT NULL,
                                father_current_district varchar(255) DEFAULT NULL,
                                father_home_village_id varchar(255) DEFAULT NULL,
                                father_home_ta_id varchar(255) DEFAULT NULL,
                                father_home_district_id varchar(255) DEFAULT NULL,
                                father_home_country_id varchar(255) DEFAULT NULL,
                                father_nationality_id varchar(255) DEFAULT NULL,
                                father_home_village varchar(255) DEFAULT NULL,
                                father_home_ta varchar(255) DEFAULT NULL,
                                father_home_district varchar(255) DEFAULT NULL,
                                father_home_country varchar(255) DEFAULT NULL,
                                father_nationality varchar(255) DEFAULT NULL,
                                father_occupation varchar(255) DEFAULT NULL,
                                father_residential_country_id varchar(255) DEFAULT NULL,
                                father_residential_country varchar(255) DEFAULT NULL,
                                father_foreigner_current_district_id varchar(255) DEFAULT NULL,
                                father_foreigner_current_village_id varchar(255) DEFAULT NULL,
                                father_foreigner_current_ta_id varchar(255) DEFAULT NULL,
                                father_foreigner_current_district varchar(255) DEFAULT NULL,
                                father_foreigner_current_village varchar(255) DEFAULT NULL,
                                father_foreigner_current_ta varchar(255) DEFAULT NULL,
                                father_foreigner_home_district_id varchar(255) DEFAULT NULL,
                                father_foreigner_home_village_id varchar(255) DEFAULT NULL,
                                father_foreigner_home_ta_id varchar(255) DEFAULT NULL,
                                father_foreigner_home_district varchar(255) DEFAULT NULL,
                                father_foreigner_home_village varchar(255) DEFAULT NULL,
                                father_foreigner_home_ta varchar(255) DEFAULT NULL,
                                headman_verified varchar(255) DEFAULT NULL,
                                headman_verification_date date DEFAULT NULL,
                                church_verified varchar(255) DEFAULT NULL,
                                church_verification_date date DEFAULT NULL,
                                informant_id_number varchar(255) DEFAULT NULL,
                                informant_first_name varchar(255) DEFAULT NULL,
                                informant_middle_name varchar(255) DEFAULT NULL,
                                informant_last_name varchar(255) DEFAULT NULL,
                                informant_first_name_code varchar(255) DEFAULT NULL,
                                informant_last_name_code varchar(255) DEFAULT NULL,
                                informant_middle_name_code varchar(255) DEFAULT NULL,
                                informant_relationship_to_deceased varchar(255) DEFAULT NULL,
                                informant_relationship_to_deceased_other varchar(255) DEFAULT NULL,
                                informant_current_village_id varchar(255) DEFAULT NULL,
                                informant_current_ta_id varchar(255) DEFAULT NULL,
                                informant_current_district_id varchar(255) DEFAULT NULL,
                                informant_current_village varchar(255) DEFAULT NULL,
                                informant_current_other_village varchar(255) DEFAULT NULL,
                                informant_current_ta varchar(255) DEFAULT NULL,
                                informant_current_other_ta varchar(255) DEFAULT NULL,
                                informant_current_district varchar(255) DEFAULT NULL,
                                informant_current_country varchar(255) DEFAULT NULL,
                                informant_addressline1 varchar(255) DEFAULT NULL,
                                informant_addressline2 varchar(255) DEFAULT NULL,
                                informant_city varchar(255) DEFAULT NULL,
                                informant_phone_number varchar(255) DEFAULT NULL,
                                informant_foreign_state varchar(255) DEFAULT NULL,
                                informant_foreign_district varchar(255) DEFAULT NULL,
                                informant_foreign_village varchar(255) DEFAULT NULL,
                                informant_foreign_address varchar(255) DEFAULT NULL,
                                informant_signed varchar(255) DEFAULT NULL,
                                informant_signature_date date DEFAULT NULL,
                                informant_designation varchar(255) DEFAULT NULL,
                                informant_office_name varchar(255) DEFAULT NULL,
                                informant_office_address varchar(255) DEFAULT NULL,
                                certifier_first_name varchar(255) DEFAULT NULL,
                                certifier_middle_name varchar(255) DEFAULT NULL,
                                certifier_last_name varchar(255) DEFAULT NULL,
                                certifier_license_number varchar(255) DEFAULT NULL,
                                certifier_signed varchar(255) DEFAULT NULL,
                                date_certifier_signed date DEFAULT NULL,
                                position_of_certifier varchar(255) DEFAULT NULL,
                                other_position_of_certifier varchar(255) DEFAULT NULL,
                                acknowledgement_of_receipt_date datetime DEFAULT NULL,
                                facility_code varchar(255) DEFAULT NULL,
                                district_code varchar(255) DEFAULT NULL,
                                created_by varchar(255) DEFAULT NULL,
                                changed_by varchar(255) DEFAULT NULL,
                                _deleted tinyint(1) NOT NULL DEFAULT '0',
                                _rev varchar(255) DEFAULT NULL,
                                updated_at datetime DEFAULT NULL,
                                created_at datetime DEFAULT NULL,
                                PRIMARY KEY (person_id)
                              ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
                              SET FOREIGN_KEY_CHECKS = 1;"
    SimpleSQL.query_exec(create_people_table)    

end
