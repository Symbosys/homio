// Models
export 'models/marketplace_enums.dart';
export 'models/digital_product_models.dart';
export 'models/home_decor_models.dart';
export 'models/material_models.dart';
export 'models/property_models.dart';
export 'models/labour_models.dart';
export 'models/order_models.dart';
export 'models/marketplace_mock_data.dart';

// Services
export 'services/marketplace_service.dart';
export 'services/cart_service.dart';
export 'services/order_service.dart';

// Shared Widgets
export 'widgets/marketplace_scaffold.dart';
export 'widgets/marketplace_header.dart';
export 'widgets/marketplace_filter_bar.dart';
export 'widgets/product_card.dart';
export 'widgets/spec_row.dart';
export 'widgets/verified_badge.dart';
export 'widgets/price_display.dart';
export 'widgets/empty_marketplace_state.dart';
export 'widgets/marketplace_banner.dart';
export 'widgets/marketplace_bottom_sheet.dart';
export 'widgets/rating_stars.dart';
export 'widgets/quantity_selector.dart';
export 'widgets/cart_sheet.dart';

// Pages
export 'overview/marketplace_overview_page.dart';
export 'digital_products/digital_products_page.dart';
export 'home_decor/home_decor_page.dart';
export 'materials/materials_page.dart';
export 'properties/properties_page.dart';
export 'labour_services/labour_services_page.dart';
export 'orders/orders_page.dart';

// Backward compatibility type aliases for legacy route builders
import 'overview/marketplace_overview_page.dart';
import 'digital_products/digital_products_page.dart';
import 'home_decor/home_decor_page.dart';
import 'materials/materials_page.dart';
import 'properties/properties_page.dart';
import 'labour_services/labour_services_page.dart';
import 'orders/orders_page.dart';

typedef ClientMarketplaceHubPage = ClientMarketplaceOverviewPage;
typedef ClientDigitalStorePage = ClientMarketplaceDigitalProductsPage;
typedef ClientDecorStorePage = ClientMarketplaceHomeDecorPage;
typedef ClientMaterialsStorePage = ClientMarketplaceMaterialsPage;
typedef ClientPropertiesPage = ClientMarketplacePropertiesPage;
typedef ClientHireLabourPage = ClientMarketplaceLabourServicesPage;

// Unambiguous aliases
typedef MarketplaceOverviewPage = ClientMarketplaceOverviewPage;
typedef DigitalProductsPage = ClientMarketplaceDigitalProductsPage;
typedef HomeDecorPage = ClientMarketplaceHomeDecorPage;
typedef LabourServicesPage = ClientMarketplaceLabourServicesPage;
typedef OrdersPage = ClientMarketplaceOrdersPage;
