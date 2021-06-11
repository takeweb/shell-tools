以下Dockerコンテナにて作業
cd /data/kajima_build/release/tools

--iField(土木用)のビルド-------------------------------------------------------------------------------------------------------
◆リリース日が「2018年3月22日」で「ifield-api」及び「ifield-web」を両方ビルドする場合
./build_ifield_dbk.sh -n all -d 20190322
                   or
./build_ifield_dbk.sh -d 20190322

◆リリース日が「2018年3月22日」で「ifield-api」のみビルドする場合
./build_ifield_dbk.sh -n api -d 20190322

◆リリース日が「2018年3月22日」で「ifield-web」のみビルドする場合
./build_ifield_dbk.sh -n web -d 20190322

◆リリース日が「2018年3月22日」で「dev_kajima_hirakata」向けにのみビルドする場合
./build_ifield_dbk.sh -d 20190322 -s dev_kajima_hirakata

--iField(日下川用)のビルド-------------------------------------------------------------------------------------------------------
◆リリース日が「2018年3月22日」で「ifield-api」及び「ifield-web」を両方ビルドする場合
./build_ifield_sps.sh -n all -d 20190322
                   or
./build_ifield_sps.sh -d 20190322

◆リリース日が「2018年3月22日」で「ifield-api」のみビルドする場合
./build_ifield_sps.sh -n api -d 20190322

◆リリース日が「2018年3月22日」で「ifield-web」のみビルドする場合
./build_ifield_sps.sh -n web -d 20190322

◆リリース日が「2018年3月22日」で「dev_kajima_hirakata」向けにのみビルドする場合
./build_ifield._sps.sh -d 20190322 -s dev_kajima_hirakata

--バッチ(location-uploader以外)のビルド---------------------------------------------------------------------------------
◆リリース日が「2018年3月22日」で「speed-summarizer」を初期ビルドする場合
　⇒libやshもコピーする
./build_batch_dbk.sh -n speed-summarizer -d 20190322 -m init

◆リリース日が「2018年3月22日」で「speed-summarizer」を更新ビルドする場合
./build_batch.sh -n speed-summarizer -d 20190322 -m mod
                   or
./build_batch.sh -n speed-summarizer -d 20190322

--バッチ(location-uploader)のビルド-------------------------------------------------------------------------------------
◆リリース日が「2018年3月22日」で「location-uploader」を初期ビルドする場合
　⇒libやshもコピーする
./build_location-uploader.sh -d 20190322 -m init

◆リリース日が「2018年3月22日」で「location-uploader」を更新ビルドする場合
./build_location-uploader.sh -d 20190322 -m mod
                   or
./build_location-uploader.sh -d 20190322

以上