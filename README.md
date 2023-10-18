# ADVENTUREWORKS

Adventure Works (AW) is a bicycle manufacturer with over 500 distinct products, 20,000 customers and 31,000 orders.
AW wants to use data strategically to guide its decisions to become a Data Driven company. For this, they elaborated some business questions that should guide the development of the facts and dimensions tables for the Data Warehouse (DW) modeling.

To start the project and obtain quick results, the option was to start with the sales area, but some tables from other areas were necessary to obtain the desired information.

There are doubts about schedule, costs involved and whether there will be a return on the investment used, and that's why this data pipeline was built.

The project was conceived and sponsored by AW's director of innovation, João Muller, and also has the support of the company's CEO, Carlos Silveira. Silvana Teixeira, commercial director, thinks that the amount invested in the project could have been directed towards promotional actions that would generate immediate sales results. In addition, she does not see how the creation of a modern data infrastructure will help her commercial department, since other promises to make the company data driven failed to achieve the results. The IT director, Nilson Ramos, is responsible for ensuring access to data and appointed the analyst, Gabriel Santos, to assist with access issues. Gabriel is currently responsible for administering the databases and answering specific questions for the business areas that require the use of SQL.

## DATA DESCRIPTION

Transactional database: Postgres

There are 68 tables divided into 5 schemas:
- HR (Human Resources);
- Production (Production);
- Person (People);
- Purchasing (Purchases).
- Sales (Sales).

The ER Adventure Works (OLTP Schema) can be checked through the link <https://raw.githubusercontent.com/dpavancini/analytics-engineering/main/AdventureWorks/AdventureWorksERD.jpeg>

## BUSINESS QUESTIONS

- What is the number of orders, quantity purchased and total amount negotiated per product, type of card, reason for sale, date of sale, customer, status, city, state and country?
- What are the products with the highest average ticket per month, year, city, state and country?
- Who are the 10 best customers by total amount negotiated filtered by product, card type, reason for sale, date of sale, status, city, state and country?
- What are the 5 best cities in terms of total value negotiated by product, type of card, reason for sale, date of sale, customer, status, city, state and country?
- What is the number of orders, quantity purchased, total amount traded per month and year (hint: time series chart)?
- Which product has the highest quantity purchased for the "Promotion" reason?

## RUNNING dbt

After successfully cloning the remote repository, it is recommended to run a test to confirm that profiles.yml and dbt_project.yml are configured and running correctly, and to double-check dependencies and necessary connections.

To do this, the command to be executed is:

`dbt debug`

Assured that all settings are working correctly, you can start loading and transforming the data.

The load and transform steps are addressed to Google Cloud Platform (GCP). Each project member has its own dedicated schema, which should be used for its development.

To install the packages described in the packages.yml file, you can run:

`dbt deps`

## MODELS

The process to run the models can be done in several ways, either in a modular way (one specific model at a time), in order to run all the models at once, or in other ways. Below are the codes for each command:

The command below runs all models at once:

`dbt run --full-refresh`

To run only the specified model:

`dbt run --select my_model` 

To run the specified model and all models that this model depends on to generate:

`dbt run --select +my_model` or dbt `dbt run --select tag:my_tag`

To run the specified model and all models that are impacted by it:

`dbt run --select my_model+`

## TESTS 

Tests are modeled to ensure data quality. To run them, just:

`dbt test`

dbt test runs all tests on data from created models. There are two types of tests:

- Validation of schemas, inserted in the *schema.yml file;
- Test of data written in SQL;
- The dbt test runs both types of tests and displays the results in the console.

When you make changes to dbt scripts, please follow the dbt code style guidelines and conventions and also ensure that the models are running correctly and that all tests have passed.

## DOCUMENTATION IN dbt 

Good documentation for dbt models helps us to manage and understand the data sets involved in the project.

The data about each column must be documented in the different schemas.yml files for the different layers of data processing and transformation:

- Sources;
- Staging;
- Marts.

Each layer will have its own schemas.yml file. The more simplified documentation includes information about the tables, containing name and description. The more robust documentation includes the name of the tables, the name of their columns, their respective descriptions and also the tests of these columns.

## Generating dbt docs

dbt provides a simple way to generate documentation for the project and render it as a website, the dbt docs.

Inside the project folder, there is a packages.yml file. In this file we put the packages and versions of the dbt dependencies used in the project. The command to install these dependencies is:

`dbt deps`

It is important to note that, if this has not been done yet, it must be done before the next steps. Doing a dbt run before having dbt deps will fail.

After that, to generate the documentation, use the command:

`dbt docs generate`

This command will generate a target folder. This folder itself becomes the documentation. To view the dbt Docs, that is, interpret the target folder, use:

dbt docs serve - which hosts a local server and assembles documentation.

This dbt docs documentation is very complete and very useful to understand how the model is organized and how the tables are related. This is important both for the project management by the current members, as well as for the project management. knowledge thinking about future new members or scalability of other projects.

## VERSION CONTROL

Versioning is done with git. This is mainly composed of a master/main branch, which is where the created files are available for production, and a develop branch, which aggregates recent changes made to the code. New features or changes must be developed in branches with the following pattern:

`git checkout -b feature/new_branch_name`

This command creates a new branch called "feature/new_branch_name". Prefer small commits with clear messages about what changes were made in each commit.

A very important practice is to always try to leave the branch you are in, go back to develop, so that you can create a new branch. This avoids making changes on top of other changes that haven't even been approved for development yet. For that:

git checkout develop
git checkout -b feature/new_branch_name

After the feature is finished, fully tested and with the changes saved in the repo, create a PR (Pull Request) for the branch deveplop using the PR's template.

Once the PR is approved, the changes will be merged into the develop branch, where they will be tested along with the other steps of the project that run in parallel. Only then will the changes be merged and sent to production. Also, the sooner changes are merged into develop, the branch on which the PR was created can be closed.

To understand more deeply the process of accumulating different branches for different features, read more about the workflow with [gitflow](https://www.atlassian.com/us/git/tutorials/comparing-workflows/gitflow- workflow).

## ADVENTUREWORKS ELT

At first, the AdventureWorks data were extracted from the transactional database (postgres) to the Data Warehouse (Big Query). In the DW, there is a `data_source` folder with all raw data from the transactional database separated by schema. The extraction part of the pipeline (EL) was done through Stitch Data, connected to Big Query.

In the data transformation phase, dbt was used, where the staging folder contains the sources YAML file (sources). At this stage, only the tables that would be used to assemble the fact tables and dimensions (DW Conceptual Diagram) were chosen.

Thus, using good modeling practices, with a staging for each source, the SAP (erp source) folder was created with the company's erp data.

To answer the business questions, 5 dimensions and 1 fact were created:

- dim_address: retrieve the customer address information such as city, state and country;
- dim_customers: retrieve customer's name.;
- dim_products: retrieve each product information;
- dim_credit_card: retrieve the credit card type used on each order;
- dim_sales_reason: retrieve the sale reason;
- fact_sales: sales fact table with informations about the orders and order details, together with the dimensions tables foreign keys.

The project was versioned through GitHub, which can be seen at the link: <https://github.com/cayod/dbt-challenge>. Each user has their stg dataset in DW. Thus, a profile must be configured for each user (as already specified above).

Thus, the project was separated into a development environment and a production (deployment) environment. For each modification in the project, a Pull Request (PR) must be opened, which should be approved in the repository before being merged into production. When the PR is approved, a job was configured in dbt to run the dbt commands (build, tests, run) and allocate the modified data in the project's production dataset in BigQuery `dbt_cdias`.

## BUSINESS INTELIGENCE

The data from the production dataset is connected to the Looker Studio dashboard and dashboard creation tool. In this way, it is possible to generate the panels that will answer the business questions specified by the client.