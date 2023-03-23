[![Build Status](https://github.com/ken6078/iTunes_Search_Application_UIKit/actions/workflows/build.yml/badge.svg?branch=main "Build Status")](https://github.com/ken6078/iTunes_Search_Application/actions/workflows/build.yml "Build Status")
#  iTunes Search Application UIKit
An app for connecting iTunes Search API and showing details of the song, album, vocalist, etc.

## Screenshots
<p>
  <p>推薦畫面&錯誤頁面</p>
  <div float="left">
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/SearchPage.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/EmptySearchResult.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/SearchError.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/DetailError.png?raw=true" width="200" />
  </div>
  <br>
  <p>歌曲畫面</p>
  <div float="left">
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/SearchSong.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/SongDetail.png?raw=true" width="200" />
  </div>
  <br>
  <p>專輯畫面</p>
  <div float="left">
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/AlbumSearch.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/AlbumDetail.png?raw=true" width="200" />
  </div>
  <br>
  <p>歌手畫面</p>
  <div float="left">
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/ArtistSearch.png?raw=true" width="200" />
    <img src="https://github.com/ken6078/iTunes_Search_Application_UIKit/blob/main/Screenshot/ArtistDetail.png?raw=true" width="200" />
  </div>
  <br>
</p>


## iTunes Search API
Document:
https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html

## Requirements library
Name    | Version | Link
--------|-------- | -----------------------------------------------
Kanna   | 5.2.7  | [Github](https://github.com/tid-kijyun/Kanna)

## Requirements version
Name    | Version
----------|-----------
Swift      | 5.0+
iOS        | 16.0+
Xcode    | 14.0+

## Setup
``` bash
git clone https://github.com/ken6078/iTunes_Search_Application_UIKit.git
cd iTunes_Search_Application_UIKit
pod install
open iTunes_Search_Application_UIKit.xcworkspace
