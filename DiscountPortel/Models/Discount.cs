using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DiscountPortel.Models
{
    public partial class Discount
    {
        [Key]
        public int DiscountId { get; set; }
        [StringLength(100)]
        public string DiscountName { get; set; }
        public bool? IsActive { get; set; }
    }
}
