// features/chat/models/photo_selection_model.dart
import 'package:image_picker/image_picker.dart';

/// Photo selection item model
class PhotoSelectionItem {
  final XFile photo;
  final int selectionOrder; // Selection order, starting from 1
  final String id;

  const PhotoSelectionItem({
    required this.photo,
    required this.selectionOrder,
    required this.id,
  });

  /// Get photo path
  String get path => photo.path;

  /// Get photo name
  String get name => photo.name;

  /// Get file size
  Future<int> get size => photo.length();

  PhotoSelectionItem copyWith({XFile? photo, int? selectionOrder, String? id}) {
    return PhotoSelectionItem(
      photo: photo ?? this.photo,
      selectionOrder: selectionOrder ?? this.selectionOrder,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhotoSelectionItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Photo selection state model
class PhotoSelectionState {
  final List<XFile> availablePhotos; // List of available photos
  final Map<String, PhotoSelectionItem> selectedPhotos; // Selected photos, key is photo.path
  final bool isLoading;
  final String? errorMessage;
  final bool hasPermission;
  final int maxSelectionCount; // Maximum selection count

  const PhotoSelectionState({
    this.availablePhotos = const [],
    this.selectedPhotos = const {},
    this.isLoading = false,
    this.errorMessage,
    this.hasPermission = false,
    this.maxSelectionCount = 9, // Default maximum 9 selections
  });

  /// Get selected photo count
  int get selectedCount => selectedPhotos.length;

  /// Check if selection limit is reached
  bool get isSelectionLimitReached => selectedCount >= maxSelectionCount;

  /// Check if there are selected photos
  bool get hasSelectedPhotos => selectedPhotos.isNotEmpty;

  /// Get sorted list of selected photos
  List<PhotoSelectionItem> get selectedPhotosList {
    final list = selectedPhotos.values.toList();
    list.sort((a, b) => a.selectionOrder.compareTo(b.selectionOrder));
    return list;
  }

  /// Check if photo is selected
  bool isPhotoSelected(XFile photo) {
    return selectedPhotos.containsKey(photo.path);
  }

  /// Get photo selection order (if selected)
  int? getPhotoSelectionOrder(XFile photo) {
    return selectedPhotos[photo.path]?.selectionOrder;
  }

  /// Toggle photo selection state
  PhotoSelectionState togglePhotoSelection(XFile photo) {
    final photoPath = photo.path;
    final newSelectedPhotos = Map<String, PhotoSelectionItem>.from(
      selectedPhotos,
    );

    if (newSelectedPhotos.containsKey(photoPath)) {
      // If already selected, deselect
      final removedItem = newSelectedPhotos.remove(photoPath)!;

      // Reorder subsequent photos
      final reorderedPhotos = <String, PhotoSelectionItem>{};
      int newOrder = 1;

      for (final item in selectedPhotosList) {
        if (item.selectionOrder < removedItem.selectionOrder) {
          reorderedPhotos[item.path] = item;
          newOrder = item.selectionOrder + 1;
        } else if (item.selectionOrder > removedItem.selectionOrder) {
          reorderedPhotos[item.path] = item.copyWith(selectionOrder: newOrder);
          newOrder++;
        }
      }

      return copyWith(selectedPhotos: reorderedPhotos);
    } else {
      // If not selected and limit not reached, add selection
      if (!isSelectionLimitReached) {
        final newItem = PhotoSelectionItem(
          photo: photo,
          selectionOrder: selectedCount + 1,
          id: photoPath,
        );
        newSelectedPhotos[photoPath] = newItem;
        return copyWith(selectedPhotos: newSelectedPhotos);
      }
      return this; // Limit reached, no changes
    }
  }

  /// Clear all selections
  PhotoSelectionState clearSelection() {
    return copyWith(selectedPhotos: {});
  }

  PhotoSelectionState copyWith({
    List<XFile>? availablePhotos,
    Map<String, PhotoSelectionItem>? selectedPhotos,
    bool? isLoading,
    String? errorMessage,
    bool? hasPermission,
    int? maxSelectionCount,
    bool clearError = false,
  }) {
    return PhotoSelectionState(
      availablePhotos: availablePhotos ?? this.availablePhotos,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasPermission: hasPermission ?? this.hasPermission,
      maxSelectionCount: maxSelectionCount ?? this.maxSelectionCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhotoSelectionState &&
        other.availablePhotos == availablePhotos &&
        other.selectedPhotos == selectedPhotos &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.hasPermission == hasPermission &&
        other.maxSelectionCount == maxSelectionCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      availablePhotos,
      selectedPhotos,
      isLoading,
      errorMessage,
      hasPermission,
      maxSelectionCount,
    );
  }
}
