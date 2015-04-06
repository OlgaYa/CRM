// // $(document).on('ready page:load', function(){
// $(document).ready(function(){
//   var $notifier = $('.notifier');

//   var $commonDialog   = $('#common-dialog');
//   var $commentsDialog = $('#comments_dialog');
//   var $declinedCommentDialog = $('#declined-comment');
//   var $priceDialog = $('#price-dialog');
//   var $messagesDialog = $('#messages-dialog');
//   var $linksDialog = $('#links-dialog');

//   var $textEditor = $('#text-editor');
//   var $commentBody = $('#comment_body');
//   var $priceInput = $('#price');
//   var $linkInp = $('#link-inp');


// // =========================== DIALOGS INIT ======================================= //

//   //dialog for fields name, source, skype, email, links
//   $commonDialog.dialog({
//     autoOpen: false,
//     closeOnEscape: true,
//     resizable: false,
//     maxHeight: 200,
//     width: 300,
//     closeText: 'close',
//     open: function (event, ui){
//       $td = $commonDialog.data('$currentTD');
//       $td.active();
//       if($td.hasClass('links')){
//         var tdContent = '';
//         $td.children('a').each(function(){ 
//           tdContent += $(this).attr('href') + ' ';
//         });
//         $textEditor.val(tdContent.trim());
//       } else {
//         var tdContent = $td.text();
//         $textEditor.val(tdContent.trim());
//       }
//     },
//     close: function (event, ui){
//       $td = $commonDialog.data('$currentTD');
//       $td.nonActive();
//     }
//   });

//    // dialog for comments editor
//   $commentsDialog.dialog({
//     autoOpen: false,
//     modal: true,
//     width: 300,
//     close: function(event, ui){
//       $td = $commentsDialog.data('$td')
//       $(this).children('div').remove();
//       $td.nonActive();      
//     },
//     open: function(event, ui){
//       $td = $commentsDialog.data('$td');
//       $td.active();      
//     }
//   });

//   // //dialog for change date
//   // var flag = false;
//   // $('.date-input').datepicker({
//   //   dateFormat: 'yy-mm-dd',
//   //   onSelect: function(date, obj){
//   //     flag = true;
//   //   },
//   //   onClose: function(date, obj){
//   //     if(flag){
//   //       var task_id = obj.input.parents().eq(1).attr('id');
//   //       var sold_task_id = $(obj.input).siblings('.id').val();
//   //       var filedName = obj.input.attr('name');
//   //       var path;
//   //       var values = { 'field': filedName, 'value': date };
//   //       if(filedName == 'date'){
//   //         path = 'tasks/' + task_id; 
//   //       } else {
//   //         path = 'sold_tasks/' + sold_task_id;
//   //       }
//   //       $.when(sendARequest(path, values)).always(function(data, textStatus, jqXHR){
//   //         if(textStatus == 'success'){
//   //           notifie( capitalize(filedName) + ' has been successfully updated!', $notifier);
//   //         } else {
//   //           error('', $notifier);
//   //         }
//   //       })
//   //       flag = false;      
//   //     }
//   //   }
//   // });

//   // popup after chenge status to "Decline"
//   var reload = true;
//   $declinedCommentDialog.dialog({
//     autoOpen: false,
//     modal: true,
//     title: 'Please describe the reason of refusal',
//     close: function(event, ui){
//       if(reload){
//         location.reload(true);
//       }
//     }, 
//     buttons: 
//       [ 
//         { 
//           text: 'Close',
//           click: function(){
//             $(this).dialog('close');
//             location.reload(true);
//           }
//         },
//         {
//           text: 'Save',
//           click: function(){
//             task_id = $(this).data('task_id');
//             body = $('#declined_comment_body').val();
//             $('#declined_comment_body').val("");
//             if(body.length > 0){
//               addComment(task_id, body);
//               changeStatus(task_id, $(this).data('field_name'), $(this).data('field_value'), $(this).data('$field'), 'declined');
//               reload = false; 
//               $(this).dialog('close');
//               reload = true;
//             }
//           }
//         }
//       ]
//   });

//   //dialog for price
//   $priceDialog.dialog({
//     autoOpen: false,
//     height: 100,
//     open: function(event, ui){
//       $td = $priceDialog.data('$td');
//       $td.active();
//     }, 
//     close: function(event, ui){
//       $priceInput.val("");
//       $td = $priceDialog.data('$td');
//       $td.nonActive();
//     }
//   });

//   $messagesDialog.dialog({
//     autoOpen: false,
//     dialogClass: 'no-close',
//     maxHeight: 300,
//     show: {
//       effect: "blind",
//       duration: 300
//     },
//     hide: {
//       effect: "explode",
//       duration: 300
//     },
//     open: function(event, ui){
//     }
//   });

//   $linksDialog.dialog({
//     autoOpen: false,
//     title: 'Links',
//     buttons: 
//       [
//         {
//           text: 'Add link',
//           click: function(){
//             var href = $linkInp.val();
//             var task_id = $linksDialog.data('task_id');
//             if(href.length > 0) {
//               var alt = href.match(/[a-z0-9]*(\.?[a-z0-9]+)\.[a-z]{2,10}(:[0-9]{1,10})?(.\/)?/)[0]
//               var values = { 'task_id': task_id, 'alt': alt, 'href': href }; // add_comment_task_id == Task.id
//               $.ajax({
//                 type: 'POST',
//                 url: '/tasks/create_link',
//                 dataType: 'html',
//                 success: function(resp){
//                   $linksDialog.children('.link_list').append($.parseHTML(resp));
//                   $('#'+task_id).children('.links').children('.link_list').append($.parseHTML(resp));
//                   updateDate(task_id);
//                   $linkInp.val("");
//                 },
//                 data: values 
//               });              
//             }
//           }
//         }
//       ],
//     open: function(){
//       $td = $linksDialog.data('$td');
//       $td.active();
//     },
//     close: function(){
//       $td = $linksDialog.data('$td')
//       $(this).children('div').remove();
//       $td.nonActive(); 
//     }
//   });

// // =========================== EVENTS ======================================= //
  
//   // ======= open  name, source, skype, links, email editor EVENT ========= //
//   $('.editable-field').on('dblclick', function(){    
//     closeAllDialogs();
//     title = $(this).attr('name');    
//     $commonDialog.dialog('option', 'title', capitalize(title));
//     $commonDialog.data('$currentTD', $(this));
//     $commonDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
//     $commonDialog.dialog('open');
//   });

//   // update field after press enter on text editor (common dialog)
//   $textEditor.on('keypress', function(e){
//     if(e.keyCode == 13 ){
//       $td = $commonDialog.data('$currentTD');
//       var editorContent = $textEditor.val();
//       var filedName = $td.attr('name');
//       var taskId = $td.parent().attr('id');
      

//       if($td.hasClass('links')){
//         arr = editorContent.split(' ');
//         var $links_result;
//         $td.empty();
//         for(i=0; i<arr.length; i += 1){
//           if(arr[i]){
//             $a = $(document.createElement('a'));
//             $a.attr('href', arr[i]);
//             $a.attr('target', '_blank');
//             $td.append($a.text(arr[i].match(/[a-z0-9]*(\.?[a-z0-9]+)\.[a-z]{2,5}(:[0-9]{1,5})?(.\/)?/)[0]));
//             $td.append($(document.createElement('br')));
//           }
//         }
//       } else {
//         $td.html(editorContent);
//       }      
//       $commonDialog.dialog('close');
//       var path = 'tasks/' + taskId;
//       var values = { 'field': filedName, 'value': editorContent }
//       $.when(sendARequest(path, values, taskId)).always(function(data, textStatus, jqXHR){
//         if(textStatus == 'success'){
//           notifie(capitalize(filedName) + 'has been successfully updated!', $notifier);
//         } else {
//           error('', $notifier);
//         }
//       });
//     }
//   });

//   // =========================== open price editor EVENT ================================== //
//   $('.price').on('dblclick', function() {
//     closeAllDialogs();
//     sold_task_id = $(this).children('.id').val();
//     $td_field = $(this).children()
    
//     $priceInput.val($(this).children('div').text().trim())
//     $priceDialog.data('$td', $(this));
//     $priceDialog.data('sold_task_id', sold_task_id);
//     $priceDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) } );
//     $priceDialog.dialog('open');
//   });

//   $priceInput.on('keypress', function(e){
//     if(e.keyCode == 13 ){
//       var price = $priceInput.val();
//       if(price.length > 0){
//         var sold_task_id = $priceDialog.data('sold_task_id');
//         $.when(sendARequest('sold_tasks/' + sold_task_id, 
//                             {'field': 'price', 'value': price }, sold_task_id)).always(function(data){
//           if(data == 'success') { 
//             $td_field.empty();
//             $td_field.html(price);
//             $priceDialog.dialog('close');
//             notifie('Price was successful updated', $notifier)      
//           } else {
//             error('', $notifier);
//           }      
//         });
//       } else {
//         error('Please type only numbers', $notifier);
//       }
//     }
//   });

//   // ============================== LINKS EVENTS ================================== //
//   $('.links').on('dblclick', function(e){
//     closeAllDialogs();
//     var $td = $(this) // cell
//     var task_id = $td.parent().attr('id') // tr.attr('id') == Task.id
//     $linksDialog.data('task_id', task_id);
//     $linksDialog.data('$td', $td);    
//     $linksDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) } );;    
//     $linksDialog.dialog('open');
//     $linksDialog.prepend($td.children().clone())
//   });

//   // ============================== COMMENTS EVENTS ================================== //
//   var timer;
//   // open comments_dialog
//   $('.comments').on('dblclick', function(e){    
//     closeAllDialogs();
//     var $td = $(this) // cell
//     var task_id = $td.parent().attr('id') // tr.attr('id') == Task.id
//     $commentsDialog.data('task_id', task_id);
//     $commentsDialog.data('$td', $td);
//     $commentsDialog.dialog('option', 'position', { my: 'right top', at: 'right top',  of: $(this) } );
//     $commentsDialog.dialog('option', 'title', 'Task - ' + task_id);
//     $commentsDialog.dialog('open'); // open new dialog
//     $commentsDialog.prepend($td.children().clone())
//   });

//   // save comment
//   $('.comment_save').on("click", function(){
//     var body = $commentBody.val();
//     var task_id = $commentsDialog.data('task_id');
//     if(body.length > 0) {
//       addComment(task_id, body);
//     }
//   });

//   function addComment(task_id, body){
//     var values = { 'task_id': task_id, 'body': body }; // add_comment_task_id == Task.id
//     $.ajax({
//       type: 'POST',
//       url: 'comments',
//       dataType: 'html',
//       success: function(resp){
//         $commentsDialog.children('.comment_list').append($.parseHTML(resp));
//         $('#'+task_id).children('.comments').children('.comment_list').append($.parseHTML(resp));
//         updateDate(task_id);
//         $commentBody.val("");
//       },
//       data: values 
//     });
//   }

// // ================ messages EVENTS ====================================== //
//   $('.messages').on('dblclick', function(e){
//     closeAllDialogs();
//     $messagesDialog.dialog('option', 'position', { my: 'left top', at: 'left top', of: $(this)} );
//     $messagesDialog.dialog('option', 'width', $(this).width());
//     $messagesDialog.append($(this).children().clone());
//     $messagesDialog.dialog('open');
//   });

//   $messagesDialog.on('mouseleave', function(){
//     $messagesDialog.dialog('close');
//     $messagesDialog.empty();
//   });

// // ================ change Selct_fields EVENTS ==================== //
//   $('.user, .status, .source').on('change', function(event){  
//     var task_id = $(this).parents().eq(1).attr('id');
//     var $field = $(this);       
//     var field_name = $(this).attr('name');
//     var field_value = $(this).val();
//     var field_text = $(this).children(':selected').text().toLowerCase();
//     switch(field_name){
//     case 'status_id': {
//       if(field_text == 'declined'){
//         closeAllDialogs();
//         $declinedComment = $('#declined-comment');
//         $declinedComment.data('field_name', field_name);
//         $declinedComment.data('task_id', task_id);
//         $declinedComment.data('field_value', field_value);
//         $declinedComment.data('$field', $field);
//         $declinedComment.dialog('open');
//       } else {       
//         if(field_text == 'assigned_meeting'){
//           $('#myModal').modal()
//         }
//         changeStatus(task_id, field_name, field_value, $field, field_text);
//       }
//     }
//     break; 
//     case 'user_id': {
//       changeSelection(task_id, field_name, field_value, $field, 'Task was successful reassigned');
//     }
//     break;
//     case 'source_id': {
//       changeSelection(task_id, field_name, field_value, $field, 'Source was successful changed');
//     }
//     break;
//     }
//     return false;
//   });

//   function changeStatus(task_id, field_name, field_value, $field, field_text){
//     $.when(sendARequest('tasks/' + task_id, { 'field': field_name, 'value': field_value }, task_id)).always(function(data){
//       if(data == 'success'){
//         d = new Date();
//         $field.parents().eq(1).children('.date').children('.date-input').val(d.yyyymmdd());   
//         // check at what page happend this event            
//         switch(getParameterByName('only')){
//         case 'sold': {
//           moveTo(task_id, field_text);                  
//         }
//         break;
//         case 'declined': {
//           moveTo(task_id, field_text);       
//         }
//         break;
//         default: {
//           if(field_text == 'declined' || field_text == 'sold'){                   
//             moveTo(task_id, field_text);
//           } else {
//             notifie('Task status was successful changed', $notifier)
//           }
//         }
//         }           
//       } else {
//         error('', $notifier);
//       }      
//     });
//   }

//   function changeSelection(task_id, field_name, field_value, $field, mess){
//     $.when(sendARequest('tasks/' + task_id, { 'field': field_name, 'value': field_value }, task_id)).always(function(data){
//       if(data == 'success') { 
//           notifie(mess, $notifier)      
//       } else {
//         error('', $notifier);
//       }      
//     });
//   }

//   function moveTo(task_id, path){
//     $('#'+task_id).remove();
//     switch(path) {
//     case 'declined': {
//       notifie('Task was successful moved to "Declined tasks"', $notifier)
//     }
//     break;

//     case 'sold': {
//       notifie('Task was successful moved to "Sold tasks"', $notifier)
//     }
//     break;

//     default: {
//       notifie('Task was successful moved to "Open tasks"', $notifier)
//     }
//     break;
//     }
//   }

//   //function parse value of params with 'name' 
//   function getParameterByName(name) {
//     var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
//         results = regex.exec(location.search);
//     return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
//   }

// // ========================== AJAX ========================================= //
//   function sendARequest(path, values, task_id){
//     if( ['topic', 'source_id', 'name'].indexOf(values.field) === -1 ){
//       updateDate(task_id);
//     }
//     return $.ajax({
//             type: 'PATCH',
//             url: path,
//             dataType: 'json',
//             data: values 
//           });
//   }

// //============================ HELPERS ============================================//

//   function updateDate(task_id) {
//     d = new Date();
//     $('#'+task_id).children('.date').children('.date-input').val(d.yyyymmdd());   
//   }  

//   $.fn.active = function(){
//     this.addClass('active-td');
//   }

//   $.fn.nonActive = function(){
//     this.removeClass('active-td');
//   }  

//   Date.prototype.yyyymmdd = function() {
//     var yyyy = this.getFullYear().toString();
//     var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
//     var dd  = this.getDate().toString();
//     return yyyy +'-'+(mm[1]?mm:"0"+mm[0]) +'-'+ (dd[1]?dd:"0"+dd[0]); // padding
//   }  

//   function closeAllDialogs(){
//     $commonDialog.dialog('close');
//     $priceDialog.dialog('close');
//     $linksDialog.dialog('close');
//     $messagesDialog.dialog('close');
//   }  
// });