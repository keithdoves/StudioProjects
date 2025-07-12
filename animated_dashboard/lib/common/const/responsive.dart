

// 모바일_        0767px        /  BottomNavigationBar, MainContent_Mobile
// 태블릿_        0768px        /  NavRail, MainContent_Tablet
// 데스크탑        1024px       /  NavRail_Extended
// 데스크탑_대형    1280px       /  MainContent_Desktop
// 데스크탑_초대형   1440px       /  Right Side Bar Appear


class BreakPoint{




}

/// The minimum width for the tablet layout and above.
///
/// This is the point where the UI transitions from `BottomNavigationBar`
/// to `NavRail` and `MainContent_Mobile` to `MainContent_Tablet`.
///
/// **Value: 400.0**
const double MOBILE_MAX_WIDTH = 440.0;


/// The minimum width for the tablet layout and above.
///
/// This is the point where the UI transitions from `BottomNavigationBar`
/// to `NavRail` and `MainContent_Mobile` to `MainContent_Tablet`.
///
/// **Value: 768.0**
const double TABLET_MIN_WIDTH = 768.0;

/// The minimum width for the desktop layout and above.
///
/// This is the point where the `NavRail` extends to `NavRail_Extended`.
///
/// **Value: 1024.0**
const double DESKTOP_MIN_WIDTH = 1024.0;

/// The minimum width for the wide desktop layout.
///
/// This is the point where the `MainContent_Tablet` changes to
/// `MainContent_Desktop` layout.
///
/// **Value: 1280.0**
const double DESKTOP_WIDE_MIN_WIDTH = 1280.0;

/// The minimum width for the extra-wide desktop layout.
///
/// This is the point where the `Right Side Bar` appears.
/// This breakpoint is suitable for very large monitors (e.g., 1440p+).
///
/// **Value: 1440.0**
const double DESKTOP_EXTRA_WIDE_MIN_WIDTH = 1440.0;

const double DETAIL_PANEL_WIDTH_COMPACT = 500.0; // 768px 미만
const double DETAIL_PANEL_WIDTH_TABLET = 600.0; // 1024px 도달 시
const double DETAIL_PANEL_WIDTH_DESKTOP = 700.0; // 1280px 도달 시
const double DETAIL_PANEL_WIDTH_EXTRA_WIDE = 800.0; // 1440px 도달 시 (그 이상)


//For The Widget
const double DASH_BOX_WIDTH = 250.0;
const double DASH_MAIN_GRAPH_WIDTH = 800.0;
const double DASH_SIDE_CONTENT_WIDTH = 300.0;

//For The Layout
const double DASH_SIDE_LAYOUT_WIDTH = 350.0;
const double DASH_MAIN_LAYOUT_WIDTH = 800.0;

//For Navigation
const double DASH_USE_NAV_RAIL = 600.0;
