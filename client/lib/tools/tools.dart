class Tools {

    static String formatCreatedAt(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      if ((difference.inDays / 365).floor() == 1) {
        return '1 year ago';
      }
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays >= 30) {
      if ((difference.inDays / 30).floor() == 1) {
        return '1 month ago';
      }
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays >= 7) {
      if ((difference.inDays / 7).floor() == 1) {
        return '1 week ago';
      }
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      }
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      }
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  
}