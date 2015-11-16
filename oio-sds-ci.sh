export OIO_CDI_DIR="/tmp"
sudo apt-get update
sudo apt-get install -y git
sudo useradd openio -m -d /home/openio
su - openio -c "git clone https://github.com/GuillaumeDelaporte/oio-sds-ci ${OIO_CDI_DIR}/oio-sds-ci"
sudo ${OIO_CDI_DIR}/oio-sds-ci/build.sh
sudo ${OIO_CDI_DIR}/oio-sds-ci/setup.sh
su - openio -c ${OIO_CDI_DIR}/oio-sds-ci/run_tests.sh
