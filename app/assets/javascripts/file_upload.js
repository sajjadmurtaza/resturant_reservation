/**
 * Created by faizanali on 4/6/15.
 */
$(document).ready(function() {
    $('.uploadField').click(function() {
        $(this).next().click();
    });
    return $('input[type=file]').change(function() {
        return $(this).parent().find('.uploadField').val($(this).val());
    });
});
