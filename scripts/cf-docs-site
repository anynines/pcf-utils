#!/bin/bash

git_clone_update() {
	if [ ! -d $WORK_DIR/$1 ]; then
		git clone https://github.com/cloudfoundry/$1 $WORK_DIR/$1
	fi

	cd $WORK_DIR/$1
	git pull
}

echo "###### Sync and host CF Docs locally ######"
if [ $# -lt 1 ]; then
	echo "Usage: ./cf-docs-site.sh <work-dir>"
	printf "\t %s \t\t %s \n" "work-dir:" "Specify the work directory"
	exit 1
fi

if [ ! -d $1 ]; then
	logError "Non-existant directory: $2"
fi

export WORK_DIR=$1

git_clone_update docs-book-cloudfoundry
git_clone_update docs-cloudfoundry-concepts
git_clone_update docs-dev-guide
git_clone_update docs-cf-admin
git_clone_update docs-services
git_clone_update docs-deploying-cf
git_clone_update docs-bosh
git_clone_update docs-running-cf
git_clone_update docs-buildpacks

cd $WORK_DIR/docs-book-cloudfoundry
bundle install
bundle exec bookbinder publish local

rm -rf final_app/Gemfile.lock
rm -rf final_app/Gemfile

cd final_app
ruby app.rb
