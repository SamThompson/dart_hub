import 'package:dart_hub/ui/paginated_list/paginated_list_view.dart';

abstract class PaginatorFactory<T> {
  Paginator<T> buildPaginator();
}
